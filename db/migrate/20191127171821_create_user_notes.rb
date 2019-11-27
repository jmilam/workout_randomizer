class CreateUserNotes < ActiveRecord::Migration[5.2]
  def change
    create_table :user_notes do |t|
      t.integer :user_id
      t.text :note, null: false
      t.timestamps
    end
  end
end
