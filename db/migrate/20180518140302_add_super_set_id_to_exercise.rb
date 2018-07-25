class AddSuperSetIdToExercise < ActiveRecord::Migration[5.1]
  def change
    add_column :exercises, :super_set_id, :integer
  end
end
