class UserPreviousWorkout < ApplicationRecord
	belongs_to :user
	belongs_to :workout

	has_many :exercises, through: :workout
end
