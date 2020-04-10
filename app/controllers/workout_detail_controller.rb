class WorkoutDetailController < ApplicationController
  # layout 'nav'
  def index
    workout_details = WorkoutDetail.where(user_previous_workout: UserPreviousWorkout.where(user: current_user))
                                   .includes(:exercise, :user_previous_workout)
    @workouts = workout_details.order('user_previous_workouts.workout_date DESC')
                               .group_by do |workout_detail|
                                 workout_detail.user_previous_workout.workout 
                               end
    @workout_stats = UserPreviousWorkout.for_google_charts(workout_details.group_by do |workout_detail|
                                 workout_detail.user_previous_workout.workout 
                               end).to_json.html_safe
  end
end
