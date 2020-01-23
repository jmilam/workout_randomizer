class RenameWorkoutDetailWOrkoutGroupId < ActiveRecord::Migration[5.2]
  def change
    rename_column :workout_details, :workout_group_id, :workout_id
  end
end
