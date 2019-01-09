class CreateWorkoutGroupSpecifiedDays < ActiveRecord::Migration[5.1]
  def change
    create_table :workout_group_specified_days do |t|
    	t.integer :workout_group_id, null: false
    	t.integer :workout_day_num, null: false

      t.timestamps
    end
  end
end
