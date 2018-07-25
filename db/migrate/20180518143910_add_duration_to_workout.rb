class AddDurationToWorkout < ActiveRecord::Migration[5.1]
  def change
    add_column :workouts, :duration, :integer, default: 4
  end
end
