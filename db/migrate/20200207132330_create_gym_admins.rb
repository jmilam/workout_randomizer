class CreateGymAdmins < ActiveRecord::Migration[5.2]
  def change
    create_table :gym_admins do |t|
      t.integer   :gym_id
      t.integer   :user_id

      t.timestamps
    end

    remove_column :gyms, :admin_ids
  end
end
