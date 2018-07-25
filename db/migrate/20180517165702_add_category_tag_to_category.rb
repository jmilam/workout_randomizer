class AddCategoryTagToCategory < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :tag, :integer, default: 1
  end
end
