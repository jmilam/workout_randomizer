class AddUserToFoodPairing < ActiveRecord::Migration[5.2]
  def change
    add_column :food_groups, :user_id, :integer
  end
end
