class AddCurrentWorkoutGroupToUser < ActiveRecord::Migration[5.1]
  def change
  	add_column :users, :current_workout_group, :integer
  	add_index :users, :current_workout_group
  end
end
