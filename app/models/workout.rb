class Workout < ApplicationRecord
	has_many :workout_groups, dependent: :destroy
	has_many :user_previous_workouts, through: :workout_groups, source: 'workout_details'
	has_many :exercises, through: :workout_groups

	belongs_to :category
	belongs_to :gym

	validates :name, :frequency, presence: true

	def self.valid_workout_with_workout_groups(user)
		begin
			workout = user.gym.workouts.includes(:exercises)
																 .joins(:category)
																 .where(categories: {goal_id: user.goal_id })
																 .sample

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
