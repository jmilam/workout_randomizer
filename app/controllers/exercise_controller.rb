class ExerciseController < ApplicationController
  layout 'nav'
  def new
    @workout_group = WorkoutGroup.find(params[:workout_group_id])
    @workout = @workout_group.workout
    @exercise = if params[:exercise_params]
                  @workout_group.exercises.new(exercise_params)
                else
                  @workout_group.exercises.new
                end
    @total_exercises = @workout_group.exercises.count == 0 ? 1 : @workout_group.exercises.count
  end

  def edit
    @exercise = Exercise.find(params[:id])
    @kiosk = current_user.gym.kiosks.find_by(exercise_id: @exercise.id)
    @kiosk_number = @kiosk.nil? ? '' : @kiosk.kiosk_number
    @total_exercises = @exercise.workout_group.exercises.count
  end

  def create
    @exercise = Exercise.new(exercise_params)

    begin
      @exercise.save!

      unless params[:kiosk_number].blank?
        current_user.gym.kiosks.create!(gym_id: current_user.gym_id, exercise_id: @exercise.id, kiosk_number: params[:kiosk_number])
      end

      flash[:notice] = "Exercise #{@exercise.name} was successfully added to your workout."
      redirect_to edit_workout_path(@exercise.workout_group.workout.id)
    rescue ActiveRecord::RecordInvalid => error
      flash[:alert] = "There was an error when updating exercise: #{error}"
      redirect_to new_exercise_path(workout_group_id: params[:exercise][:workout_group_id],
                                    exercise: params[:exercise].permit!)
    end
  end

  def update
    @exercise = Exercise.find(params[:id])
    @superset_exercise = Exercise.find(params[:exercise][:super_set_id]) unless params[:exercise][:super_set_id].blank?

    exercise_circuit = ExerciseCircuit.joins(:exercises).where(exercises: {id: @exercise.id})

    begin
      Exercise.transaction do
        unless params[:super_set_id].blank?
          exercise_circuit = exercise_circuit.empty? ? ExerciseCircuit.create : exercise_circuit.first

          params[:super_set_id].each do |super_set_exercise|
            Exercise.find(super_set_exercise).update!(exercise_circuit_id: exercise_circuit.id)
          end

          @exercise.update!(exercise_circuit_id: exercise_circuit.id)
        end

        @exercise.update!(exercise_params)

        @kiosk = current_user.gym.kiosks.find_by(exercise_id: @exercise.id)
        if @kiosk.nil? && !params[:kiosk_number].blank?
          current_user.gym.kiosks.create!(gym_id: current_user.gym_id, exercise_id: @exercise.id, kiosk_number: params[:kiosk_number].to_i)
        elsif !@kiosk.nil?
          @kiosk.update(kiosk_number: params[:kiosk_number].to_i)
        end
      end

      flash[:notice] = "Exercise #{@exercise.common_exercise.name} was successfully updated."
      redirect_to edit_workout_path(@exercise.workout.id)
    rescue ActiveRecord::RecordInvalid => error
      flash[:alert] = "There was an error when updating exercise: #{error}"
      render :edit
    end
  end

  def destroy
    @exercise = Exercise.find(params[:id])

    @workout_ids_with_exercise = WorkoutDetail.all.map(&:exercise_id).delete_if { |num| num != params[:id].to_i }

    if !@workout_ids_with_exercise.empty?
      flash[:alert] = 'Exercise cannot be deleted because someone has used it with their workout. It will mess up their history. We have disabled it instead.'
      redirect_to edit_workout_path(@exercise.workout_id)
    elsif @exercise.delete
      flash[:notice] = 'Exercise was successfully delete.'
      redirect_to edit_workout_path(@exercise.workout_id)
    else
      flash[:alert] = "There was an error when deleting exercise: #{@exercise.error}"
      render :edit
    end
  end

  def get_all_for_workout_group
    @workout = Workout.find(params[:id]) unless params[:id].blank?
    @user = User.find(params[:user_id])

    @previous_workouts = @user.user_previous_workouts.includes(:exercises).where(workout_id: @workout&.id)
    @previous_workouts = @previous_workouts.where.not(workout_date: params[:workout_date]) unless params[:edit_mode] == "true"
    @previous_workout = @previous_workouts.last

    unless @workout.nil?
      @last_workout = @previous_workout.workout_details
      @exercise_groups = Exercise.group_by_circuit(@workout)
      @exercise_group = Exercise.get_exercise(@user, @exercise_groups, params[:workout_date], true)
    end

    @manual_entry = true
    @edit_mode = params[:edit_mode] || "false"

    @button_title = "Submit Exercise Details"

    respond_to do |format|
      format.js
    end
  end

  def add_exercise_to_workout
    @exercise = Exercise.new(exercise_params)
    @exercise.common_exercise_id = params[:exercise_id]
    @exercise.common_equipment_id = params[:equipment_id]

    begin
      @exercise.save!

      unless params[:kiosk_number].blank?
        current_user.gym.kiosks.create!(gym_id: current_user.gym_id, exercise_id: @exercise.id, kiosk_number: params[:kiosk_number])
      end

      flash[:notice] = "Exercise #{@exercise.common_exercise.name} was successfully added to your workout."
      redirect_to edit_workout_path(@exercise.workout_id)
    rescue ActiveRecord::RecordInvalid => error
      flash[:alert] = "There was an error when updating exercise: #{error}"
      redirect_to edit_workout_path(@exercise.workout_id)
    end
  end

  protected

  def exercise_params
    params.require(:exercise).permit(:name, :description, :instructions, :warm_up, :warm_up_details, :set_count,
                                     :workout_group_id, :rep_range, :priority, :band, :video, :time_by_minutes, :workout_id)
  end
end
