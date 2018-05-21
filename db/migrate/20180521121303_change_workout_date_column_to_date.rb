class ChangeWorkoutDateColumnToDate < ActiveRecord::Migration[5.1]
  def change
  	remove_column :workout_details, :workout_date
  	add_column :workout_details, :workout_date, :date
  end
end
