class AddWarmUpBooleanAndDescriptionToExercise < ActiveRecord::Migration[5.1]
  def change
  	add_column :exercises, :warm_up, :boolean, default: false
  	add_column :exercises, :warm_up_details, :string, default: ""
  end
end
