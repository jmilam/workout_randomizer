class AddUserPreviousWOrkoutIdToWorkotuDetail < ActiveRecord::Migration[5.1]
  def change
  	add_column :workout_details, :user_previous_workout_id, :integer
  end
end
