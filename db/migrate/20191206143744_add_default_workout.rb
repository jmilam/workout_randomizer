class AddDefaultWorkout < ActiveRecord::Migration[5.2]
  def change
    add_column :workouts, :user_default, :boolean, default: false
  end
end
