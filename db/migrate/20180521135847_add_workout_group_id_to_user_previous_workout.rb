class AddWorkoutGroupIdToUserPreviousWorkout < ActiveRecord::Migration[5.1]
  def change
    add_column :user_previous_workouts, :workout_group_id, :integer
    remove_column :user_previous_workouts, :workout_id
  end
end
