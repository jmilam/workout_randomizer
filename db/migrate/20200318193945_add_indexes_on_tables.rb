class AddIndexesOnTables < ActiveRecord::Migration[5.2]
  def change
    add_index :categories, :gym_id
    add_index :common_exercises, :gym_id
    add_index :exercises, :workout_id
    add_index :fitness_classes, :gym_id
    add_index :goals, :user_id
    add_index :gym_admins, [:gym_id, :user_id]
    add_index :likes, :workout_id
    add_index :measurements, :user_id
    add_index :message_groups, :inbox_id
    add_index :user_previous_workouts, :user_id
    add_index :users, :current_workout
    add_index :users, :gym_id
    add_index :wods, [:workout_id, :gym_id]
    add_index :workouts, :gym_id
  end
end
