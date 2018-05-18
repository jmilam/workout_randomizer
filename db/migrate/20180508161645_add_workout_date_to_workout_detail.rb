class AddWorkoutDateToWorkoutDetail < ActiveRecord::Migration[5.1]
  def change
  	add_column :workout_details, :workout_date, :string, default: Date.today.in_time_zone.strftime("%m/%d/%y")
  end
end
