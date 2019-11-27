class AddRobotToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :not_a_robot, :boolean, default: false
  end
end
