class CreateWokoutGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :wokout_groups do |t|
    	t.integer :workout_id
    	t.string :name
      t.timestamps
    end
  end
end
