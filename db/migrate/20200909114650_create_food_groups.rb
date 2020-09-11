class CreateFoodGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :food_groups do |t|
      t.string :name
      t.integer :gym_id
      t.timestamps
    end
  end
end
