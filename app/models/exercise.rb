class Exercise < ApplicationRecord
	belongs_to :workout_group
	has_many :workout_details

	validates :name, presence: true
end
