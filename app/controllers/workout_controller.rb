class WorkoutController < ApplicationController
  layout 'nav'

  def index
    @user = current_user

    if @user.current_workout.nil?
      @workout, @workout_group = Workout.valid_workout_with_workout_groups(@user)
    else
      @workout = Workout.find(current_user.current_workout)
      @workout_group = @workout.workout_groups.to_a.delete_if { |group| @user.this_weeks_workouts.include?(group.id) }&.sample
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
    @categories = current_user.gym.categories.enabled
    @exercises = CommonExercise.all.order(:name)
    @equipment = CommonEquipment.all.order(:name)
    @selected_exercises = []
    @selected_equipment = []
  end

  def create
    @categories = current_user.gym.categories.enabled
    @workout = current_user.gym.workouts.new(workout_params)
    @workout.created_by_user_id = current_user.id

    begin
      params[:selected_exercise_ids].split(',').zip(params[:selected_exercises_set_counts].split(','),
                                                    params[:selected_equipment_ids].split(','),
                                                    params[:selected_exercises_rep_counts].split(',')).each do |exercise_details|

        @workout.exercises.new(rep_range: exercise_details[3], set_count: exercise_details[1],
                               common_exercise_id: exercise_details[0].to_i, common_equipment_id: exercise_details[2])
      end


      @workout.save!

      flash[:notice] = "Workout #{@workout.name} was successfully created. Let's add some exercises now."
      redirect_to new_workout_path
    rescue ActiveRecord::RecordInvalid => error
      flash[:alert] = "There was an error when creating exercise: #{error}"
      render :new
    rescue ActiveRecord::StandardError => error
      flash[:alert] = "There was an error when creating exercise: #{error}"
      render :new
    end
  end

  def edit
    @workout = Workout.find(params[:id])
    @editable = @workout.editable_by_user?(current_user)
    @user_already_liked = !@workout.likes.user_liked_workout(current_user.id, @workout.id).empty?
    @workout_users = User.where(current_workout: @workout.id)
    # @workout_groups = @workout.workout_groups.includes(:exercises)
    @exercises = @workout.exercises.includes(:common_exercise)
  end

  def show
    @workout = Workout.find(params[:id])
    @categories = current_user.gym.categories.enabled
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
    @workouts = Workout.sort_by_likes(current_user).in_groups_of(2)
    @workouts = Workout.remove_nils(@workouts)
    @top_workouts = Workout.top_workouts_by_category(@workouts).first
  end

  def accept_workout
    current_user.update!(current_workout: params[:workout_id])

    redirect_to profile_index_path
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

  def manual_workout
    @workouts = Workout.all.includes(:exercises)
    @users = current_user.gym.users
    @user = current_user
    @workout_groups = []
    @manual_entry = true
  end

  def add_exercise
    selected_exercises_ids = params[:selected_exercise_ids]&.split(',') || []
    selected_exercises_set_counts = params[:selected_exercises_set_counts]&.split(',') || []
    selected_exercises_rep_counts = params[:selected_exercises_rep_counts]&.split(',') || []
    selected_equipment_ids = params[:selected_equipment_ids]&.split(',') || []

    @selected_exercises = [{id: params[:exercise_id], name: CommonExercise.find(params[:exercise_id]).name,
                            set_count: params[:set_count], rep_count: params[:rep_count]}]
    @selected_equipment = [{id: params[:equipment_id], name: CommonEquipment.find(params[:equipment_id]).name}]

    selected_exercises_ids.each_with_index do |ex_id, idx|
      @selected_exercises << {id: ex_id, name: CommonExercise.find(ex_id).name, set_count: selected_exercises_set_counts[idx],
                              rep_count: selected_exercises_rep_counts[idx]}
    end

    selected_equipment_ids.each do |equip_id|
      @selected_equipment << {id: equip_id, name: CommonEquipment.find(equip_id).name}
    end
  end

  protected

  def workout_params
    params.require(:workout).permit(:name, :category_id)
  end
end
