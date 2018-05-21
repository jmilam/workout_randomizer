class WorkoutDetail < ApplicationRecord
	belongs_to :exercise
	belongs_to :workout_group
	belongs_to :user
	has_many :user_previous_workouts
end
