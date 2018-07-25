class CreateInboxes < ActiveRecord::Migration[5.1]
  def change
    create_table :inboxes do |t|
      t.integer  :user_id

      t.timestamps
    end

    add_index :inboxes, :user_id
  end
end
