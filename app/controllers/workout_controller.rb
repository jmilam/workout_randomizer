class WorkoutController < ApplicationController
  layout 'nav'
  def index
    @user = current_user

    if @user.current_workout.nil?
      @workout, @workout_group = Workout.valid_workout_with_workout_groups(@user)
    else
      @workout = Workout.find(current_user.current_workout)
      @this_weeks_workouts = @user.this_weeks_workouts
      @workout_group = @workout.workout_groups.to_a.delete_if { |group| @this_weeks_workouts.include?(group.id) }.sample
      @last_workout = @workout_group.workout_details.where(user_id: @user.id) unless @workout_group.nil?
      @already_worked_out = !@user.user_previous_workouts
                                  .where(workout_date: Date.today.strftime('%m/%d/%y'))
                                  .empty?
    end
    @exercise_groups = @workout_group.exercises.group_by(&:super_set_id)
    unless @exercise_groups[nil].nil?
      @exercise_groups[nil].each do |nil_group|
        @exercise_groups["#{nil_group.id}a"] = [nil_group]
      end
     end

    @exercise_groups.delete(nil)
  end

  def new
    @workout = Workout.new
    @categories = Category.all
  end

  def create
    @workout = current_user.gym.workouts.new(workout_params)

    begin
      @workout.save!

      flash[:notice] = "Workout #{@workout.name} was successfully created. Let's add some exercises now."
      redirect_to new_workout_group_path(workout_id: @workout.id)
    rescue ActiveRecord::RecordInvalid => error
      flash[:alert] = "There was an error when updating exercise: #{error}"
      render :new
    end
  end

  def edit
    @workout = Workout.find(params[:id])
    @user_already_liked = !@workout.likes.user_liked_workout(current_user.id, @workout.id).empty?
    @workout_users = User.where(current_workout: @workout.id)
    @workout_groups = @workout.workout_groups.includes(:exercises)
  end

  def show
    @workout = Workout.find(params[:id])
  end

  def update
    @workout = Workout.find(params[:id])

    begin
      @workout.update!(workout_params)

      flash[:notice] = "Workout #{@workout.name} was successfully updated."
      redirect_to edit_workout_path(workout_id: @workout.id)
    rescue ActiveRecord::RecordInvalid => error
      flash[:alert] = "There was an error when updating exercise: #{error}"
      render :show, id: @workout.id
    end
  end

  def list
    @current_user = current_user
    @workouts = current_user
                  .gym
                  .workouts
                  .includes(:exercises)
                  .sort_by { |workout| p workout.likes.count }
                  .reverse
                  .in_groups_of(2)
    @workouts = Workout.remove_nils(@workouts)
  end

  def accept_workout
    current_user.update!(current_workout: params[:workout_id])

    redirect_to edit_workout_path(params[:workout_id])
  end

  def accept_deny_workout
    user = current_user
    workout = Workout.find(params[:workout_id])

    if params[:accept]
      begin
        user.current_workout = workout.id
        user.save!(validate: false)
        redirect_to workout_index_path
      rescue StandardException => error
        flash[:alert] = error
        redirect_to workout_id
      end
    elsif params[:deny]
      redirect_to workout_index_path
    end
  end

  def stop_workout
    current_user.current_workout = nil
    current_user.current_workout_group = nil

    if current_user.save!(validate: false)
      flash[:notice] = 'Awesome job on the workout. Your next workout is waiting for you.'
    end
  rescue StandardError => error
    flash[:alert] = error
  ensure
    redirect_to profile_index_path
  end

  def like_workout
    begin
      workout = Workout.find(params[:workout_id])
      like = workout.likes.new(workout_id: workout.id, user_id: current_user.id)
      if like.save
        flash[:notice] = "You liked this workout."
      else
        flash[:alert] = "Cannot like a workout more then once"
      end
    rescue StandardError => error
      flash[:alert] = error
    ensure
      redirect_to edit_workout_path(workout.id)
    end
  end

  protected

  def workout_params
    params.require(:workout).permit(:name, :frequency, :category_id, :warm_up_details, :duration)
  end
end
