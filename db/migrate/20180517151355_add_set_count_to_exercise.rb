class AddSetCountToExercise < ActiveRecord::Migration[5.1]
  def change
    add_column :exercises, :set_count, :integer, default: 3
  end
end
