class ChangeDefaultExerciseTime < ActiveRecord::Migration[5.2]
  def change
    change_column_default(:exercises, :time_by_minutes, 1)
  end
end
