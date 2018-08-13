class ExerciseController < ApplicationController
  layout 'nav'
  def new
    @workout_group = WorkoutGroup.find(params[:workout_group_id])
    @exercise = if params[:exercise_params]
                  @workout_group.exercises.new(exercise_params)
                else
                  @workout_group.exercises.new
                end
    @total_exercises = 1
  end

  def edit
    @exercise = Exercise.find(params[:id])
    @kiosk = current_user.gym.kiosks.find_by(exercise_id: @exercise.id)
    @kiosk_number = @kiosk.nil? ? '' : @kiosk.kiosk_number
    @superset_exercise = SuperSet.get_shared_exercise(@exercise)
    @total_exercises = @exercise.workout_group.exercises.count
  end

  def create
    @exercise = Exercise.new(exercise_params)
    @superset_exercise = Exercise.find(params[:exercise][:super_set_id]) unless params[:exercise][:super_set_id].blank?

    begin
      @exercise.save!

      unless params[:kiosk_number].blank?
        current_user.gym.kiosks.create!(gym_id: current_user.gym_id, exercise_id: @exercise.id, kiosk_number: params[:kiosk_number])
      end
      unless params[:exercise][:super_set_id].blank?
        super_set = SuperSet.create_or_update(@exercise, params[:exercise][:super_set_id])

        Exercise.transaction do
          @exercise.update!(exercise_params)
          @exercise.update!(super_set_id: super_set.id)
          @superset_exercise.update!(super_set_id: super_set.id)
        end
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

    begin
      Exercise.transaction do
        unless params[:exercise][:super_set_id].blank?
          super_set = SuperSet.create_or_update(@exercise, params[:exercise][:super_set_id])
          @superset_exercise.update!(super_set_id: super_set.id)
          @exercise.update!(super_set_id: super_set.id)
        end

        @exercise.update!(exercise_params)

        @kiosk = current_user.gym.kiosks.find_by(exercise_id: @exercise.id)
        if @kiosk.nil? && !params[:kiosk_number].blank?
          current_user.gym.kiosks.create!(gym_id: current_user.gym_id, exercise_id: @exercise.id, kiosk_number: params[:kiosk_number].to_i)
        elsif !@kiosk.nil?
          @kiosk.update(kiosk_number: params[:kiosk_number].to_i)
        end
      end

      flash[:notice] = "Exercise #{@exercise.name} was successfully updated."
      redirect_to edit_workout_path(@exercise.workout_group.workout.id)
    rescue ActiveRecord::RecordInvalid => error
      flash[:alert] = "There was an error when updating exercise: #{error}"
      render :edit
    end
  end

  def destroy
    @exercise = Exercise.find(params[:id])

    @workout_ids_with_exercise = WorkoutDetail.all.map(&:exercise_id).delete_if { |num| num != params[:id].to_i }

    if !@workout_ids_with_exercise.empty?
      flash[:alert] = 'Exercise cannot be deleted because someone has used it with their workout. It will mess up their history. You can hide this workout.'
      redirect_to edit_workout_path(@exercise.workout_group.workout_id)
    elsif @exercise.delete
      flash[:notice] = 'Exercise was successfully delete.'
      redirect_to edit_workout_path(@exercise.workout_group.workout_id)
    else
      flash[:alert] = "There was an error when deleting exercise: #{@exercise.error}"
      render :edit
    end
  end

  protected

  def exercise_params
    params.require(:exercise).permit(:name, :description, :instructions, :warm_up, :warm_up_details, :set_count,
                                     :workout_group_id, :rep_range, :priority)
  end
end
