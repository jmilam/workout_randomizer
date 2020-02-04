class AddClientIdToTimeCard < ActiveRecord::Migration[5.2]
  def change
    add_column :time_cards, :client_id, :integer
  end
end
