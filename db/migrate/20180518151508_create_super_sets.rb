class CreateSuperSets < ActiveRecord::Migration[5.1]
  def change
    create_table :super_sets do |t|
    	t.integer :exercise_one_id
    	t.integer :exercise_two_id
      t.timestamps
    end
  end
end
