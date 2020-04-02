class AddVideoToWorkout < ActiveRecord::Migration[5.2]
  def up
    add_attachment :workouts, :video
  end

  def down
    remove_attachment :workouts, :video
  end
end
