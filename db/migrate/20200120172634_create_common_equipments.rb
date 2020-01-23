class CreateCommonEquipments < ActiveRecord::Migration[5.2]
  def change
    create_table :common_equipments do |t|
      t.string  "name", null: false

      t.timestamps
    end
  end
end
