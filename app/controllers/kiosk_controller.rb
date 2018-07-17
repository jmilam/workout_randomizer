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
  	workouts_complete = WorkoutDetail.where(workout_date:Date.today.beginning_of_week.strftime("%Y-%m-%d")..Date.today.end_of_week.strftime("%Y-%m-%d"), user_id: @user.id).map(&:workout_group_id).uniq

  	if @user.current_workout_group.nil? && WorkoutDetail.where(workout_date: Date.today.strftime("%Y-%m-%d"), user_id: @user.id).empty?
  		current_workout_group = @workout.workout_groups.to_a.delete_if { |workout_group| workouts_complete.include?(workout_group.id) }.sample.id
			@user.update(current_workout_group: current_workout_group)
  	elsif @user.current_workout_group.nil?
  		return
  	end

		@workout_group = WorkoutGroup.find(@user.current_workout_group)
		@last_workout = @workout_group.workout_details.where(user_id: @user.id) unless @workout_group.nil?

		@exercise_groups = Exercise.group_super_sets(@workout_group)

		@exercise_group = Exercise.get_exercise(current_user, @exercise_groups)
  end

  def log_exercise
  	WorkoutDetail.transaction do
  		begin
				workout = Workout.find(current_user.current_workout)
				workout_group = WorkoutGroup.find(current_user.current_workout_group)
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

				exercise_groups = Exercise.group_super_sets(workout_group)

				current_user.update(current_workout_group: nil) if Exercise.get_exercise(current_user, exercise_groups).nil?
				flash[:notice] = current_user.current_workout_group.nil? ? "Great Workout! You completed todays workout!" : "Exercise Complete"
				redirect_to kiosk_exercise_path
			rescue StandardError => error

				flash[:alert] = "There was an error when saving Workout Details #{error}"
			end
		end
  end
end
