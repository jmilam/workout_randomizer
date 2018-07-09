class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
    	t.integer :inbox_id
    	t.integer :receipient_id, null: false
    	t.string	:subject, null: false
    	t.text		:detail
      t.timestamps
    end

    add_index :messages, :inbox_id
    add_index :messages, :receipient_id
    add_index :messages, [:inbox_id, :receipient_id]
  end
end
