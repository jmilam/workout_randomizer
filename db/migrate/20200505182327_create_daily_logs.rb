class CreateDailyLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :daily_logs do |t|
      t.date    :calendar_date
      t.integer :daily_log_food_id
      t.integer :user_id
      t.timestamps
    end
  end
end
