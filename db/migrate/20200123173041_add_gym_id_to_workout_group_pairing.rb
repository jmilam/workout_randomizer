class AddGymIdToWorkoutGroupPairing < ActiveRecord::Migration[5.2]
  def change
    add_column :workout_group_pairings, :gym_id, :integer, null: false
  end
end
