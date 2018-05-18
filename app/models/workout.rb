class Workout < ApplicationRecord
	has_many :workout_groups
	has_many :exercises, through: :workout_groups
	has_many :workout_details

	belongs_to :category
	belongs_to :gym

	validates :name, :frequency, presence: true

	def self.valid_workout_with_workout_groups(user)
		begin
			workout = user.gym.workouts.includes(:exercises).sample

			if workout.workout_groups.empty?
				raise "Not Workout Groups setup for this workout!"
			else
				[workout, workout.workout_groups.sample]
			end
		rescue
			retry
		end
	end

	def self.remove_nils(workouts)
		workouts.each { |e| e.delete_if {|val| val.nil? }}
	end 
end
