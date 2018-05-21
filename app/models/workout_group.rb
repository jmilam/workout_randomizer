class WorkoutGroup < ApplicationRecord
	belongs_to :workout
	has_many :exercises
	has_many :workout_details
end
