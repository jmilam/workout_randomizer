class AddDurationToTask < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :duration, :integer
  end
end
