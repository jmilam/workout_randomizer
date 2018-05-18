class ProfileController < ApplicationController
	layout 'nav'
  before_action :authenticate_user!

  def index
  	@title = "#{current_user.first_name} Profile"
    @user = current_user

    unless current_user.current_workout.nil?
      @workout = Workout.find(current_user.current_workout)
  		@already_worked_out = !@workout.workout_details
  																	 .where(workout_date: Date.today.in_time_zone.strftime("%m/%d/%y"))
  																	 .empty?
    end

    @height = (@user.height/12.0).round(1).to_s.split('.')

    @bmi = @user.calculate_bmi
    @bmi_status = @user.bmi_status(@bmi)
  end
end
