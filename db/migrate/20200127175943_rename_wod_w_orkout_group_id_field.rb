class RenameWodWOrkoutGroupIdField < ActiveRecord::Migration[5.2]
  def change
    rename_column :wods, :workout_group_id, :workout_id
  end
end
