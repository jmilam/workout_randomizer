class AddProteinCarbThreshold < ActiveRecord::Migration[5.2]
  def change
    add_column :gyms, :protein_threshold, :integer, default: 30
    add_column :gyms, :carb_limit, :integer, default: 50
  end
end
