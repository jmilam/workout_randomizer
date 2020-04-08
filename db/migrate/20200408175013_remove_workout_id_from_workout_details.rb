class RemoveWorkoutIdFromWorkoutDetails < ActiveRecord::Migration[5.2]
  def change
    remove_column :workout_details, :workout_id
  end
end
