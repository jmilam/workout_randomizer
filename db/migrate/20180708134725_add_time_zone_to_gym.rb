class AddTimeZoneToGym < ActiveRecord::Migration[5.1]
  def change
  	add_column :gyms, :time_zone, :string, default: 'EST'
  end
end
