class UserPreviousWorkout < ApplicationRecord
	belongs_to :user
	belongs_to :workout_group

	has_many :exercises, through: :workout_group
	has_many :workout_details

	validates :workout_date, presence: true
	validates :workout_group_id, presence: true
end
