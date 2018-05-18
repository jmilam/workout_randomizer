class WorkoutDetailController < ApplicationController
	layout 'nav'
	def index
		@workouts = current_user.user_previous_workouts.includes(:exercises)
		@date_range = Date.today.beginning_of_week..Date.today.end_of_week
	end

	def create
		WorkoutDetail.transaction do
			begin
				workout = Workout.find(current_user.current_workout)
				params[:exercises][:workout_detail].each do |details|
					workout.workout_details.create!(details.permit!)

					if current_user.user_previous_workouts.where(workout_id: current_user.current_workout).empty?
						current_user.user_previous_workouts.create!(workout_id: current_user.current_workout)
					end
				end
			rescue StandardError => error
				flash[:alert] = "There was an error when saving Workout Details #{error}"
			ensure
				flash[:notice] = "Awesome workout!"
				redirect_to profile_index_path
			end
		end
	end

	protected

	def detail_params
		params.require(:exercises).permit(:exercise_id, :rep_1_weight, :rep_2_weight, :rep_3_weight, :rep_4_weight, :rep_5_weight,
                                 :rep_6_weight)
	end
end