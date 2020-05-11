class AddCreatedByUserIdFoods < ActiveRecord::Migration[5.2]
  def change
    add_column :foods, :created_by_user_id, :integer
  end
end
