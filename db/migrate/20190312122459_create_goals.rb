class CreateGoals < ActiveRecord::Migration[5.1]
  def change
    create_table :goals do |t|
    	t.integer :user_id, null: false
    	t.text :comment, null: false

      t.timestamps
    end
  end
end
