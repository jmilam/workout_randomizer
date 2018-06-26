class ProfileController < ApplicationController
	layout 'nav'
  before_action :authenticate_user!

  def index
  	@title = "#{current_user.first_name} Profile"
    @user = current_user
    @weeks_doing_workout = 0

    unless current_user.current_workout.nil?
      @workout = Workout.find(current_user.current_workout)
  		@already_worked_out = !@user.user_previous_workouts
  																	 .where(workout_date: Date.today.in_time_zone)
  																	 .empty?
      # @weeks_doing_workout = @workout.user_previous_workouts.count

      workout_weeks = []
      @workout.user_previous_workouts.where(user_id: @user.id).sort.group_by(&:workout_date).keys.each do |workout_date|
        workout_weeks << workout_date unless workout_weeks.include?(workout_date.beginning_of_week)
      end

      @weeks_doing_workout = workout_weeks.count
    end

    @height = (@user.height/12.0).round(1).to_s.split('.')

    @bmi = @user.calculate_bmi
    @bmi_status = @user.bmi_status(@bmi)
    
    @differences = {}
    WorkoutDetail.all.group_by(&:exercise_id).each do |detail|
      exercise = Exercise.find(detail[0])
      @differences[exercise.name] = { avg: [], max: [] }

      detail[1].each do |workout_detail|
        @differences[exercise.name][:avg] << workout_detail.avg_rep_weight
        @differences[exercise.name][:max] << workout_detail.max_rep_weight
      end 

      @differences[exercise.name].each do |key, value|
        value = value.sort!
        if value.count > 1
          @differences[exercise.name][key] = (value[1] - value[0]).round(2)
        else
          @differences[exercise.name][key] = 0.0
        end
      end
    end

    @counter = 0

    @workout_stats = UserPreviousWorkout.for_google_charts(@user.user_previous_workouts.group_by(&:workout_group_id)).to_json.html_safe
  end

  def edit
    p @user = User.find(params[:id])
    @regularity = User.regularities
    @goals = User.goals
    @gyms = Gym.all
  end

  def update
    @user = User.find(params[:id])

    if @user.update!(workout_params)
      flash[:notice] = "User successfully updated"
      redirect_to root_path
    else
      flash[:alert] = "Errors on update #{@user.errors}"
      redirect_to edit_profile_path(@user.id)
    end
  end

  protected

  def workout_params
    params.require(:user).permit(:first_name, :last_name, :height, :weight, :regularity_id, :goal_id, :gym_id)
  end
end
