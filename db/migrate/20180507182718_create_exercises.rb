class CreateExercises < ActiveRecord::Migration[5.1]
  def change
    create_table :exercises do |t|
    	t.string :name
    	t.text :description
    	t.binary :example
    	t.text :instructions

      t.timestamps
    end
  end
end
