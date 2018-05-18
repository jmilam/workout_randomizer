class RenameExcerciseWorkoutIdToWorkoutGroupId < ActiveRecord::Migration[5.1]
  def change
  	rename_column :exercises, :workout_id, :workout_group_id
  end
end
