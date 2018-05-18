class CreateUserPreviousWorkouts < ActiveRecord::Migration[5.1]
  def change
    create_table :user_previous_workouts do |t|
    	t.integer :user_id
    	t.integer :workout_id

      t.timestamps
    end
  end
end
