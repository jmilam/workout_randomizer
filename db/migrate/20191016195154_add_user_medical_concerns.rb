class AddUserMedicalConcerns < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :medical_concerns, :text
  end
end
