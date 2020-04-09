class DropSuperSetTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :super_sets
  end
end
