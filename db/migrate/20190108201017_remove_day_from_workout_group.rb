class RemoveDayFromWorkoutGroup < ActiveRecord::Migration[5.1]
  def change
  	remove_column :workout_groups, :day
  end
end
