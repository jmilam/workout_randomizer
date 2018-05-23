class ChangeRepToInt < ActiveRecord::Migration[5.1]
  def change
  	change_column :workout_details, :rep_1_weight, :integer
		change_column :workout_details, :rep_2_weight, :integer
		change_column :workout_details, :rep_3_weight, :integer
		change_column :workout_details, :rep_4_weight, :integer
		change_column :workout_details, :rep_5_weight, :integer
		change_column :workout_details, :rep_6_weight, :integer
  end
end
