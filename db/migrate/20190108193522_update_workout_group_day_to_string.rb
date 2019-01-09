class UpdateWorkoutGroupDayToString < ActiveRecord::Migration[5.1]
  def change
  	change_column :workout_groups, :day, :string, limit: 80
  end
end
