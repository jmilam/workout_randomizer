class AddIntroUrlToWorkout < ActiveRecord::Migration[5.2]
  def change
    add_column :workouts, :intro_url, :string
  end
end
