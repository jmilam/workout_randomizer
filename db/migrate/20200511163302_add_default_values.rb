class AddDefaultValues < ActiveRecord::Migration[5.2]
  def change
    change_column_default :foods, :calories, 0.0
    change_column_default :foods, :carbs, 0.0
    change_column_default :foods, :fat, 0.0
    change_column_default :foods, :protein, 0.0
  end
end
