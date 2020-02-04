class AddSubdomainToGym < ActiveRecord::Migration[5.2]
  def change
    add_column :gyms, :subdomain, :string
  end
end
