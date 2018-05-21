class AddGoalIdToCategory < ActiveRecord::Migration[5.1]
  def change
  	add_column :categories, :goal_id, :integer
  end
end
