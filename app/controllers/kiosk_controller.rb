class KioskController < ApplicationController
	skip_before_action :authenticate_user!
  def index
  end

  def create
  	user = User.find_by(pin: params[:pin])

  	sign_in user

  	if user.current_workout.nil?
  		flash[:error] = "Please login to your profile and select a workout first."
  		render :index
  	else
  		flash[:notice] = "Welcome, lets get after it."
  		redirect_to kiosk_exercise_path
  	end
  end

  def configure_exercise
  	#find current workout
  	@user = current_user
  	@workout = Workout.find(current_user.current_workout)
		@user.update(current_workout_group: @workout.workout_groups.sample.id) if @user.current_workout_group.nil? 
		@workout_group = WorkoutGroup.find(@user.current_workout_group)
		@last_workout = @workout_group.workout_details.where(user_id: @user.id) unless @workout_group.nil?
		@exercise_groups = @workout_group.exercises.group_by(&:super_set_id)
		@exercise_groups[nil].each do |nil_group|
			@exercise_groups["#{nil_group.id}a"] = [nil_group]
		end unless @exercise_groups[nil].nil?

		@exercise_groups.delete(nil)

		exercises_completed = WorkoutDetail.where(workout_date: Date.today.strftime("%Y-%m-%d"), user_id: current_user.id).map(&:exercise_id)

		exercise_ids = @exercise_groups.values.flatten.map(&:id).delete_if { |exercise_id| exercises_completed.include?(exercise_id)}
		
		@exercise_groups.each do |group, group_exercises|
			group_exercise = group_exercises.delete_if { |group_exercise| !exercise_ids.include?(group_exercise.id)}
		end

		@exercise_groups.delete_if { |key, value| value.empty? }

		unless @exercise_groups.empty?		
			@exercise_group = @exercise_groups.to_a.sample[1]
		end
  end

  def log_exercise
  	WorkoutDetail.transaction do
  		begin
				workout = Workout.find(current_user.current_workout)
				workout_date = Date.today.in_time_zone
				reference_exercise = Exercise.find(params[:exercises][:workout_detail].first[:exercise_id])

				prev_workout = current_user.user_previous_workouts.find_or_create_by!(
					workout_group_id: reference_exercise.workout_group_id,
					workout_date: Date.today.in_time_zone
				)

				params[:exercises][:workout_detail].each do |details|
					unless details['rep_1_weight'].blank?
						prev_workout.workout_details.new(details.permit!)
						workout_details = prev_workout.workout_details.create(details.permit!)	
						workout_details.update!(user_id: current_user.id)
					end
				end

				flash[:notice] = "Exercise Complete"
				redirect_to kiosk_exercise_path
			rescue StandardError => error

				flash[:alert] = "There was an error when saving Workout Details #{error}"
			end
		end
  end
end
