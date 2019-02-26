class AddTraineeFlagToUser < ActiveRecord::Migration[5.1]
  def change
  	add_column :users, :trainee, :boolean, default: true
  	add_column :users, :trainer, :boolean, default: false
  end
end
