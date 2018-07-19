class CreateKiosks < ActiveRecord::Migration[5.1]
  def change
    create_table :kiosks do |t|
    	t.integer :kiosk_number, null: false
    	t.integer :gym_id, null: false
    	t.integer :exercise_id, null: false
      t.timestamps
    end
  	add_index :kiosks, [:kiosk_number, :gym_id, :exercise_id], name: 'by_kiosk_gym_exercise_id'
  end
end
