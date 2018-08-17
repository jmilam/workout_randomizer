class AddCreatedById < ActiveRecord::Migration[5.1]
  def change
  	add_column :workouts, :created_by_user_id, :integer
  	add_column :categories, :created_by_user_id, :integer
  end
end
