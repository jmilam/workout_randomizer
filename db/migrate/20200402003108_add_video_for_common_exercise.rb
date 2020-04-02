class AddVideoForCommonExercise < ActiveRecord::Migration[5.2]
  def up
    add_attachment :common_exercises, :video
  end

  def down
    remove_attachment :common_exercises, :video
  end
end
