class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.integer :height,  null: false
      t.integer :weight,  null: false
      t.string :phone_number
      t.integer    :regularity_id, null: false
      t.integer    :goal_id, null: false
      t.string :username, null: false

      t.timestamps
    end
  end
end
