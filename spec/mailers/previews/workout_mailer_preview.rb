class WorkoutMailerPreview < ActionMailer::Preview
  def tomorrows_workout
    tomorrow_day = Date.tomorrow.cwday
    workout_group_pairings = WorkoutGroupPairing.select(:id, :workout_id).where(workout_day: tomorrow_day)
    users = User.where(current_workout_group: workout_group_pairings.map(&:id))

    user = users.first
      WorkoutMailer.with(user: user,
                         workout: Workout.includes(:exercises).find_by(id: user.current_workout)).tomorrows_workout
  end
end