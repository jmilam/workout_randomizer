class AddGymIdToCommonExercise < ActiveRecord::Migration[5.2]
  def change
    add_column :common_exercises, :gym_id, :integer
  end
end
