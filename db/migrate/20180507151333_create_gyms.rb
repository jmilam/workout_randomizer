class CreateGyms < ActiveRecord::Migration[5.1]
  def change
    create_table :gyms do |t|
      t.string :name
      t.string    :address
      t.string    :city
      t.string    :state
      t.string    :zipcode
      t.string    :phone_number
      t.string    :admin_ids

      t.timestamps
    end
  end
end
