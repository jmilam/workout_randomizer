class ExerciseController < ApplicationController
	layout 'nav'
	def new
		@workout_group = WorkoutGroup.find(params[:workout_group_id])
		@exercise = @workout_group.exercises.new
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
			render :edit
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

	protected

	def exercise_params
		params.require(:exercise).permit(:name, :description, :instructions, :warm_up, :warm_up_details, :set_count,
																		 :workout_group_id, :rep_range)
	end
end
