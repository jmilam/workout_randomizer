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
																				.where(workout_date: Date.today.strftime("%m/%d/%y"))
																				.empty?
		end
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
		@workouts = current_user.gym.workouts.includes(:exercises).in_groups_of(2)
		@workouts = Workout.remove_nils(@workouts)
	end

	def accept_deny_workout
		user = current_user
		workout = Workout.find(params[:workout_id])

		if params[:accept]
			User.transaction do 
				begin
					user.update(current_workout: workout.id)
				rescue StandardException => error
					flash[:alert] = error 
					redirect_to workout_id
				end
			end
		elsif params[:deny]
			redirect_to workout_index_path
		end
	end

	def stop_workout
		begin
			if current_user.update!(current_workout: nil)
				flash[:notice] = "Awesome job on the workout. Your next workout is waiting for you."
			end
		rescue StandardException => error
			flash[:alert] = error 
		ensure
			redirect_to profile_index_path
		end
	end

	protected

	def workout_params
		params.require(:workout).permit(:name, :frequency, :category_id, :warm_up_details, :duration)
	end
end
