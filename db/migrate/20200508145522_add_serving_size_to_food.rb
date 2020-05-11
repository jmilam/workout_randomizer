class AddServingSizeToFood < ActiveRecord::Migration[5.2]
  def change
    add_column :foods, :serving_size, :string, default: '', null: false
  end
end
