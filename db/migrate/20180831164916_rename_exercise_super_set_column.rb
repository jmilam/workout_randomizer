class RenameExerciseSuperSetColumn < ActiveRecord::Migration[5.1]
  def change
  	rename_column :exercises, :super_set_id, :exercise_circuit_id
  end
end
