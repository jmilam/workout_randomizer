class AddUserAccountDisabled < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :account_disabled, :boolean, default: false
  end
end
