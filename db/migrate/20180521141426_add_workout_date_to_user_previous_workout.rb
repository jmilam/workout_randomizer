class AddWorkoutDateToUserPreviousWorkout < ActiveRecord::Migration[5.1]
  def change
    add_column :user_previous_workouts, :workout_date, :date
  end
end
