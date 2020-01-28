class CreateCommonExercises < ActiveRecord::Migration[5.2]
  def change
    create_table :common_exercises do |t|
      t.string  "name", null: false
      t.timestamps
    end
  end
end
