class AddVideoForExercise < ActiveRecord::Migration[5.2]
  def up
    add_attachment :exercises, :video
  end

  def down
    remove_attachment :exercises, :video
  end
end
