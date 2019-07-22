class ProfileController < ApplicationController
  layout 'nav'

  def index
    @user = current_user
    @gym = @user.gym
    @title = "#{@user.first_name} Profile"
    @weeks_doing_workout = 0

    if params[:manual_exit]
      @user.update(current_workout_group: nil)
    end

    unless @user.current_workout.nil?
      @workout = Workout.find(@user.current_workout)
      current_workout_group_exercises_count = @user.current_workout_group.nil? ?
        0 : WorkoutGroup.find(@user.current_workout_group).exercises.count 

      @completed_workout = !@user.user_previous_workouts
                                  .where(workout_date: Date.today.in_time_zone)
                                  .empty?

      @weeks_doing_workout = @workout.user_previous_workouts.where(user_id: @user.id)
        .sort
        .group_by(&:workout_date)
        .keys
        .uniq { |i| i.beginning_of_week }
        .count

      @weeks_remaining = @workout.duration - @weeks_doing_workout

      if @weeks_remaining < 0
        @user.workout_complete
      end
    end

    @height = (@user.height / 12.0).round(1).to_s.split('.')

    @bmi = @user.calculate_bmi
    @bmi_status = @user.bmi_status(@bmi)

    @differences = {}

    unless @user.current_workout.nil?
      current_workout = Workout.find(@user.current_workout)
      WorkoutDetail.all.where(workout_group_id: current_workout.workout_groups.map(&:id)).group_by(&:exercise_id).each do |detail|
        exercise = Exercise.find(detail[0])
        @differences[exercise.name] = { avg: [], max: [] }

        detail[1].each do |workout_detail|
          @differences[exercise.name][:avg] << workout_detail.avg_rep_weight
          @differences[exercise.name][:max] << workout_detail.max_rep_weight
        end

        @differences[exercise.name].each do |key, value|
          value = value.sort!
          @differences[exercise.name][key] = if value.count > 1
                                               (value[1] - value[0]).round(2)
                                             else
                                               0.0
                                             end
        end
      end
    end

    @counter = 0
    @wod = Wod.where(gym_id: @user.gym.id, workout_date: Date.today).last
  end

  def edit
    @user = User.find(params[:id])
    @regularity = User.regularities
    @goals = User.goals
    @gyms = Gym.all.includes(:users)
    @trainers = @user.gym.users.trainers
    @workouts = Workout.all
  end

  def update
    @user = User.find(params[:id])

    if @user.update!(workout_params)
      flash[:notice] = 'User successfully updated'
      redirect_to profile_index_path
    else
      flash[:alert] = "Errors on update #{@user.errors}"
      redirect_to edit_profile_path(@user.id)
    end
  end

  protected

  def workout_params
    params.require(:user).permit(:first_name, :last_name, :height, :weight, :regularity_id, :current_workout, :goal_id, :gym_id, :trainer_id, :avatar)
  end
end
