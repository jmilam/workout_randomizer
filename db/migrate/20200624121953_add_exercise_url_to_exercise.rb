class AddExerciseUrlToExercise < ActiveRecord::Migration[5.2]
  def change
    add_column :exercises, :exercise_video_url, :string
  end
end
