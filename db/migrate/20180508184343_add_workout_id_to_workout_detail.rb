class AddWorkoutIdToWorkoutDetail < ActiveRecord::Migration[5.1]
  def change
    add_column :workout_details, :workout_id, :integer
  end
end
