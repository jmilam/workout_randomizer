class RenameWorkoutGroupTable < ActiveRecord::Migration[5.1]
  def change
    rename_table :wokout_groups, :workout_groups
  end
end
