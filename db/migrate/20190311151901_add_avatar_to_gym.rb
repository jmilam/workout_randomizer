class AddAvatarToGym < ActiveRecord::Migration[5.1]
  def up
    add_attachment :gyms, :logo
  end

  def down
    remove_attachment :gyms, :logo
  end
end
