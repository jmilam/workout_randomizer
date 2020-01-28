class AddWorkoutDescription < ActiveRecord::Migration[5.2]
  def change
    add_column :workouts, :details, :text
  end
end
