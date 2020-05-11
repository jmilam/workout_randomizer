class AddNutritionOnlyTouser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :nutrition_only, :boolean, default: false
  end
end
