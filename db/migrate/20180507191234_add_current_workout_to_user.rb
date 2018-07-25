class AddCurrentWorkoutToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :current_workout, :integer
  end
end
