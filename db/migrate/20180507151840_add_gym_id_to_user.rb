class AddGymIdToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :gym_id, :integer
  end
end
