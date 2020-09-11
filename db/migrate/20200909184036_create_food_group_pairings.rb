class CreateFoodGroupPairings < ActiveRecord::Migration[5.2]
  def change
    create_table :food_group_pairings do |t|
      t.integer   :food_group_id
      t.integer   :food_id
      t.integer   :serving_qty
      t.timestamps
    end
  end
end
