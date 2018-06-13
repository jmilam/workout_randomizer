class ProfileController < ApplicationController
	layout 'nav'
  before_action :authenticate_user!

  def index
  	@title = "#{current_user.first_name} Profile"
    @user = current_user
    @weeks_doing_workout = 0

    unless current_user.current_workout.nil?
      @workout = Workout.find(current_user.current_workout)
  		@already_worked_out = !@user.user_previous_workouts
  																	 .where(workout_date: Date.today.in_time_zone)
  																	 .empty?
      @weeks_doing_workout = @workout.user_previous_workouts.count
    end

    @height = (@user.height/12.0).round(1).to_s.split('.')

    @bmi = @user.calculate_bmi
    @bmi_status = @user.bmi_status(@bmi)
    
    @differences = {}
    WorkoutDetail.all.group_by(&:exercise_id).each do |detail|
      exercise = Exercise.find(detail[0])
      @differences[exercise.name] = { avg: [], max: [] }

      detail[1].each do |workout_detail|
        @differences[exercise.name][:avg] << workout_detail.avg_rep_weight
        @differences[exercise.name][:max] << workout_detail.max_rep_weight
      end 

      @differences[exercise.name].each do |key, value|
        value = value.sort!
        if value.count > 1
          @differences[exercise.name][key] = (value[1] - value[0]).round(2)
        else
          @differences[exercise.name][key] = 0.0
        end
      end
    end

    @counter = 0

    @workout_stats = UserPreviousWorkout.for_google_charts(@user.user_previous_workouts.group_by(&:workout_group_id)).to_json.html_safe
  end
end
