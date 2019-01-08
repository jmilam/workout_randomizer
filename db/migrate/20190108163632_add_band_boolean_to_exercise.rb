class AddBandBooleanToExercise < ActiveRecord::Migration[5.1]
  def change
  	add_column :exercises, :band, :boolean, default: false
  	add_column :workout_details, :band_color, :string
  end
end
