class AddNewFieldsForExercise < ActiveRecord::Migration[5.1]
  def change
  	add_column :workout_groups, :day, :integer
  	add_column :workout_groups, :ab_workout, :integer
  end
end
