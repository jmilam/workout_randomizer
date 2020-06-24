class WorkoutController < ApplicationController
  layout 'nav', except: ['list', 'new', 'manual_workout']  
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
                                                    params[:selected_exercises_rep_counts].split(','),
                                                    params[:selected_exercise_times].split(','),
                                                    params[:selected_exercise_timed].split(',')).each do |exercise_details|
        exercise = CommonEquipment.find(exercise_details[2].to_i)
        @workout.exercises.new(rep_range: exercise_details[3], set_count: exercise_details[1],
                               common_exercise_id: exercise_details[0].to_i, common_equipment_id: exercise_details[2],
                               band: exercise.name.downcase.squish == "band", time_by_seconds: exercise_details[4],
                               timed_exercise: exercise_details[5])

      end

      @workout.save!

      flash[:notice] = "Workout #{@workout.name} was successfully created. Let's add some exercises now."
      redirect_to new_workout_path
    rescue ActiveRecord::RecordInvalid => error
      flash[:alert] = "There was an error when creating exercise: #{error}"
      redirect_to new_workout_path
      # render :new
    rescue ActiveRecord::StandardError => error
      flash[:alert] = "There was an error when creating exercise: #{error}"
      redirect_to new_workout_path
      # render :new
    end
  end

  def edit
    @workout = Workout.find(params[:id])
    @editable = @workout.editable_by_user?(current_user)
    @user_already_liked = !@workout.likes.user_liked_workout(current_user.id, @workout.id).empty?
    @workout_users = User.where(current_workout: @workout.id)
    @exercises = @workout.exercises.includes(:common_exercise)
    @common_exercises = CommonExercise.all.order(:name)
    @equipment = CommonEquipment.all.order(:name)

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
      @categories = current_user.gym.categories.enabled

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

    flash[:notice] = "New workout selected and ready to use. Click 'Start Workout' to get started."
    redirect_to profile_index_path
  end

  def stop_workout
    current_user.current_workout = nil

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
    @selected_workout = Workout.find_by(id: params[:workout_id])
    @working_date = params[:workout_date] || Date.today
    @workouts = current_user.gym.workouts.includes(:exercises).order(name: :asc)
    @users = current_user.gym.users.order(last_name: :asc)
    @user = current_user
    @workout_groups = []
    @edit_mode = params[:edit_mode] || false
    @manual_entry = true
  end

  def add_exercise
    selected_exercises_ids = params[:selected_exercise_ids]&.split(',') || []
    selected_exercises_set_counts = params[:selected_exercises_set_counts]&.split(',') || []
    selected_exercises_rep_counts = params[:selected_exercises_rep_counts]&.split(',') || []
    selected_equipment_ids = params[:selected_equipment_ids]&.split(',') || []
    selected_exercise_times = params[:selected_exercise_times]&.split(',') || []
    selected_exercise_timed = params[:selected_exercise_timed]&.split(',') || []

    @selected_exercises = [{id: params[:exercise_id], name: CommonExercise.find(params[:exercise_id]).name,
                            set_count: params[:set_count], rep_count: params[:rep_count],
                            time_by_seconds: params[:time_by_seconds], timed_exercise: params[:timed_exercise] || false}]

    @selected_equipment = [{id: params[:equipment_id], name: CommonEquipment.find(params[:equipment_id]).name}]

    selected_exercises_ids.each_with_index do |ex_id, idx|
      @selected_exercises << {id: ex_id, name: CommonExercise.find(ex_id).name, set_count: selected_exercises_set_counts[idx],
                              rep_count: selected_exercises_rep_counts[idx], time_by_seconds: selected_exercise_times[idx],
                              timed_exercise: selected_exercise_timed[idx]}
    end

    selected_equipment_ids.each do |equip_id|
      @selected_equipment << {id: equip_id, name: CommonEquipment.find(equip_id).name}
    end
  end

  protected

  def workout_params
    params.require(:workout).permit(:name, :category_id, :details, :video, :intro_url)
  end
end
