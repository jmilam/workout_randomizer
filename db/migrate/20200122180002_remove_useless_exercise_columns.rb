class RemoveUselessExerciseColumns < ActiveRecord::Migration[5.2]
  def change
    remove_column :exercises, :name
  end
end
