class CreateWorkoutGroupPairings < ActiveRecord::Migration[5.2]
  def change
    create_table :workout_group_pairings do |t|
      t.integer   :workout_id, null: false
      t.integer   :workout_group_id, null: false
      t.integer   :workout_day, null: false
      t.timestamps
    end
  end
end
