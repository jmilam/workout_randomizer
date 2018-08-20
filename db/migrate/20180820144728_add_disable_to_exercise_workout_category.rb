class AddDisableToExerciseWorkoutCategory < ActiveRecord::Migration[5.1]
  def change
  	add_column :workouts, :disabled, :boolean, default: false
  	add_column :categories, :disabled, :boolean, default: false
  	add_column :exercises, :disabled, :boolean, default: false
  end
end
