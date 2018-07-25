class CreateWorkouts < ActiveRecord::Migration[5.1]
  def change
    create_table :workouts do |t|
      t.string :name
      t.integer :frequency
      t.string :rep_range

      t.timestamps
    end
  end
end
