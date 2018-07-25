class AddCategoryIdToWorkout < ActiveRecord::Migration[5.1]
  def change
    add_column :workouts, :category_id, :integer
  end
end
