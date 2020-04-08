class RemoveWorkoutDateFromWorkoutDetail < ActiveRecord::Migration[5.2]
  def change
    remove_column :workout_details, :workout_date
  end
end
