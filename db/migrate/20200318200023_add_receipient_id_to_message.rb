class AddReceipientIdToMessage < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :recipient_id, :integer, null: :false
  end
end
