class AddTimeToExercise < ActiveRecord::Migration[5.2]
  def change
    add_column :exercises, :timed_exercise, :boolean, default: false
    add_column :exercises, :time_by_minutes, :integer, default: 30
  end
end
