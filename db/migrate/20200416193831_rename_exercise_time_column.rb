class RenameExerciseTimeColumn < ActiveRecord::Migration[5.2]
  def change
     rename_column :exercises, :time_by_minutes, :time_by_seconds
     change_column_default :exercises, :time_by_seconds, 60
  end
end
