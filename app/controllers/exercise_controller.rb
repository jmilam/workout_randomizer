class ExerciseController < ApplicationController
	layout 'nav'
	def new
		@workout_group = WorkoutGroup.find(params[:workout_group_id])
		@exercise = if params[:exercise_params]
									@workout_group.exercises.new(exercise_params)
								else
									@workout_group.exercises.new
								end
	end

	def edit
		@exercise = Exercise.find(params[:id])
		@superset_exercise = SuperSet.get_shared_exercise(@exercise)
		@workout_group = @exercise.workout_group
	end

	def create
		@exercise = Exercise.new(exercise_params)
		@superset_exercise = Exercise.find(params[:exercise][:super_set_id]) unless params[:exercise][:super_set_id].blank?

		begin
			@exercise.save!

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
			unless params[:exercise][:super_set_id].blank?
				super_set = SuperSet.create_or_update(@exercise, params[:exercise][:super_set_id])

				Exercise.transaction do 
					@exercise.update!(exercise_params)
					@exercise.update!(super_set_id: super_set.id)
					@superset_exercise.update!(super_set_id: super_set.id)
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
			flash[:alert] = "Exercise cannot be deleted because someone has used it with their workout. It will mess up their history. You can hide this workout."
			redirect_to edit_workout_path(@exercise.workout_group.workout_id)
		elsif @exercise.delete
			flash[:notice] = "Exercise was successfully delete."
			redirect_to edit_workout_path(@exercise.workout_group.workout_id)
		else
			flash[:alert] = "There was an error when deleting exercise: #{@exercise.error}"
			render :edit
		end
	end

	protected

	def exercise_params
		params.require(:exercise).permit(:name, :description, :instructions, :warm_up, :warm_up_details, :set_count,
																		 :workout_group_id, :rep_range)
	end
end
