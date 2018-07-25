class AddUserToWorkoutDetails < ActiveRecord::Migration[5.1]
  def change
    add_column :workout_details, :user_id, :integer
  end
end
