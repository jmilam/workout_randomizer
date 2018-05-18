class WorkoutGroupController < ApplicationController
	layout 'nav'
	def index
	end

	def new
		@workout = Workout.find(params[:workout_id])

		@workout_group = @workout.workout_groups.new
	end

	def edit
		@workout_group = WorkoutGroup.find(params[:id])
	end

	def create
		@workout_group = WorkoutGroup.new(workout_group_params)

		begin
			@workout_group.save!

			flash[:notice] = "Workout Group #{@workout_group.name} was successfully created. Let's add some exercises now."
			redirect_to new_exercise_path(workout_group_id: @workout_group.id)

		rescue ActiveRecord::RecordInvalid => error
			flash[:alert] = "There was an error when updating exercise: #{error}"
			render :new
		end
	end

	def update
		@workout_group = WorkoutGroup.find(params[:id])

		begin
			@workout_group.update!(workout_group_params)

			flash[:notice] = "Workout Group #{@workout_group.name} was successfully updated."
			redirect_to edit_workout_path(@workout_group.workout.id)

		rescue ActiveRecord::RecordInvalid => error
			flash[:alert] = "There was an error when updating exercise: #{error}"
			render :edit
		end
	end

	protected

	def workout_group_params
		params.require(:workout_group).permit(:name, :workout_id)
	end
end
