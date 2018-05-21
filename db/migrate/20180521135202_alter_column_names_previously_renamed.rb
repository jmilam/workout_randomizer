class AlterColumnNamesPreviouslyRenamed < ActiveRecord::Migration[5.1]
  def change
  	rename_column :workout_groups, :workout_group_id, :workout_id
  	rename_column :workout_details, :workout_id, :workout_group_id
  end
end
