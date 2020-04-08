class RemoveUserFromWorkoutDetail < ActiveRecord::Migration[5.2]
  def change
    remove_column :workout_details, :user_id
  end
end
