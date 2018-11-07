class CreateWods < ActiveRecord::Migration[5.1]
  def change
    create_table :wods do |t|
    	t.integer :workout_group_id, null: false
    	t.integer :gym_id, null: false
    	t.date :workout_date, null: false
      t.timestamps
    end
  end
end
