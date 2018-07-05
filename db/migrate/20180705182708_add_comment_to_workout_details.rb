class AddCommentToWorkoutDetails < ActiveRecord::Migration[5.1]
  def change
  	add_column :workout_details, :comment, :text, default: ''
  end
end
