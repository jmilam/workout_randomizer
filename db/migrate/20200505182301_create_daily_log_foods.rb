class CreateDailyLogFoods < ActiveRecord::Migration[5.2]
  def change
    create_table :daily_log_foods do |t|
      t.integer :food_id
      t.integer :daily_log_id
      t.timestamps
    end
  end
end
