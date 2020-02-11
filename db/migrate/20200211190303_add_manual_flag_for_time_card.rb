class AddManualFlagForTimeCard < ActiveRecord::Migration[5.2]
  def change
    add_column :time_cards, :manual_entry, :boolean, default: false
  end
end
