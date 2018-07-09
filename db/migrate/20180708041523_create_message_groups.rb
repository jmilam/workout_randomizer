class CreateMessageGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :message_groups do |t|
    	t.integer	:inbox_id
    	t.string	:subject, null: false
      t.timestamps
    end

    remove_column :messages, :subject

    add_column :messages, :message_group_id, :integer
    add_index :messages, :message_group_id
   end
end
