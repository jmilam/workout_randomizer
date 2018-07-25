class AddGymIdToWorkout < ActiveRecord::Migration[5.1]
  def change
    add_column :workouts, :gym_id, :integer
  end
end
