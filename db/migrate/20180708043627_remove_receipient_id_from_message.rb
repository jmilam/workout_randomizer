class RemoveReceipientIdFromMessage < ActiveRecord::Migration[5.1]
  def change
  	remove_column :messages, :receipient_id
  end
end
