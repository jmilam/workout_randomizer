class AddQtyToFoodLog < ActiveRecord::Migration[5.2]
  def change
    add_column :daily_log_foods , :qty, :integer, default: 1, null: false
  end
end
