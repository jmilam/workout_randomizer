class AddRepRangeToExercise < ActiveRecord::Migration[5.1]
  def change
    remove_column :workouts, :rep_range
    add_column :exercises, :rep_range, :string, default: ''
  end
end
