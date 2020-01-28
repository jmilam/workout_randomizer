class AddExerciseIdToWorkout < ActiveRecord::Migration[5.2]
  def change
    add_column :exercises, :workout_id, :integer, null: false
    remove_column :exercises, :workout_group_id
  end
end
