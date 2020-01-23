class AddColumnsForEquipmentToExercise < ActiveRecord::Migration[5.2]
  def change
    add_column :exercises, :common_exercise_id, :integer, null: false
    add_column :exercises, :common_equipment_id, :integer, null: false
  end
end
