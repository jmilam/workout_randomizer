class AddWorkoutGroupIdToWorkoutDetail < ActiveRecord::Migration[5.1]
  def change
  	rename_column :workout_groups, :workout_id, :workout_group_id
  end
end
