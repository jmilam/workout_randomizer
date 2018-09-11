class CreateExerciseCircuits < ActiveRecord::Migration[5.1]
  def change
    create_table :exercise_circuits do |t|

      t.timestamps
    end
  end
end
