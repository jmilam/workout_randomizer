class WorkoutDetail < ApplicationRecord
	belongs_to :exercise
	belongs_to :workout_group
	belongs_to :user
	belongs_to :user_previous_workout
end
