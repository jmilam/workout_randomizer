class ProfileController < ApplicationController
	layout 'nav'
  before_action :authenticate_user!

  def index
  	@title = "#{current_user.first_name} Profile"
    @user = current_user

    unless current_user.current_workout.nil?
      @workout = Workout.find(current_user.current_workout)
  		@already_worked_out = !@user.user_previous_workouts
  																	 .where(workout_date: Date.today.in_time_zone)
  																	 .empty?
    end

    @height = (@user.height/12.0).round(1).to_s.split('.')

    @bmi = @user.calculate_bmi
    @bmi_status = @user.bmi_status(@bmi)
    
    p @workout_stats = UserPreviousWorkout.for_google_charts(@user.user_previous_workouts.group_by(&:workout_group_id)).to_json.html_safe
  end
end
