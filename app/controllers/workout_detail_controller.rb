class WorkoutDetailController < ApplicationController
  layout 'nav'
  def index
    @workouts = current_user.workout_details.includes(:exercise).order(workout_date: :desc).group_by(&:workout)
    @workout_stats = UserPreviousWorkout.for_google_charts(current_user.workout_details.group_by(&:workout)).to_json.html_safe
  end

  def create
    WorkoutDetail.transaction do
      begin
        workout = Workout.find(current_user.current_workout)
        workout_date = Date.today.in_time_zone
        reference_exercise = Exercise.find(params[:exercises][:workout_detail].first[:exercise_id])

        prev_workout = current_user.user_previous_workouts.create!(
          workout_group_id: reference_exercise.workout_group_id,
          workout_date: workout_date
        )

        params[:exercises][:workout_detail].each do |details|
          next if details['rep_1_weight'].blank?
          prev_workout.workout_details.new(details.permit!)
          workout_details = prev_workout.workout_details.create(details.permit!)
          workout_details.update!(user_id: current_user.id)
        end

        flash[:notice] = 'Awesome workout!'
      rescue StandardError => error
        flash[:alert] = "There was an error when saving Workout Details #{error}"
      ensure
        redirect_to profile_index_path
      end
    end
  end

  protected

  def detail_params
    params.require(:exercises).permit(:exercise_id, :rep_1_weight, :rep_2_weight, :rep_3_weight, :rep_4_weight, :rep_5_weight,
                                      :rep_6_weight, :workout_date, :comment, :band_color)
  end
end
