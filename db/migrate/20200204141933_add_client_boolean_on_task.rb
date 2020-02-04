class AddClientBooleanOnTask < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :select_client, :boolean, default: false
  end
end
