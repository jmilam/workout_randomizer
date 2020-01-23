class RenameUserPreviusWorkoutGroupColumn < ActiveRecord::Migration[5.2]
  def change
    rename_column :user_previous_workouts, :workout_group_id, :workout_id
  end
end
