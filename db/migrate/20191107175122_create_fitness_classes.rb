class CreateFitnessClasses < ActiveRecord::Migration[5.2]
  def change
    create_table :fitness_classes do |t|
      t.integer   :gym_id
      t.string    :name
      t.integer   :duration
      t.text      :description
      t.timestamps
    end
  end
end
