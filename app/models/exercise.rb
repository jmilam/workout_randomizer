class Exercise < ApplicationRecord
	belongs_to :workout_group
	has_many :workout_details

	validates :name, presence: true

	def self.to_word(boolean)
		boolean ? 'Yes' : 'No'
	end
end
