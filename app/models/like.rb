class Like < ApplicationRecord
	belongs_to :workout

	validates :workout_id, uniqueness: { scope: :user_id }

	scope :user_liked_workout, -> (user_id, workout_id) { where(user_id: user_id, workout_id: workout_id) }
end
