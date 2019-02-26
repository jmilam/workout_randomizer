class AddTrainerIdToUser < ActiveRecord::Migration[5.1]
  def change
  	add_column :users, :trainer_id, :integer
  end
end
