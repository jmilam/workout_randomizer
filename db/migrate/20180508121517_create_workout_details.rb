class CreateWorkoutDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :workout_details do |t|
      t.integer :exercise_id
      t.float :rep_1_weight
      t.float :rep_2_weight
      t.float :rep_3_weight
      t.float :rep_4_weight
      t.float :rep_5_weight
      t.float :rep_6_weight
      t.timestamps
    end
  end
end
