class AddDefaultValuesForUser < ActiveRecord::Migration[5.1]
  def change
  	change_column :users, :height, :integer, default: 0
  	change_column :users, :weight, :integer, default: 0
  	change_column :users, :regularity_id, :integer, default: 0
  	change_column :users, :goal_id, :integer, default: 0
  end
end
