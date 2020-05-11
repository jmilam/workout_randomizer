class AddTdeeToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :tdee, :integer, default: 0
  end
end
