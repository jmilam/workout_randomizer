class AddMacrosToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :protein_total, :integer, default: 0, null: false
    add_column :users, :carb_total, :integer, default: 0, null: false
    add_column :users, :fat_total, :integer, default: 0, null: false
  end
end
