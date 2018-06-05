class UserPreviousWorkout < ApplicationRecord
	belongs_to :user
	belongs_to :workout_group

	has_many :exercises, through: :workout_group
	has_many :workout_details

	validates :workout_date, presence: true
	validates :workout_group_id, presence: true

	def self.for_google_charts(grouped_workouts)
		workout_stats = {}
		grouped_workouts.each do |previous_workout|
      workout_details = ['Date']
      previous_workout[1].each do |prev_workout|
        exercise_names = prev_workout.exercises.map(&:name)
        if workout_stats["#{prev_workout.workout_group.name}"].nil? || workout_stats["#{prev_workout.workout_group.name}"].include?(exercise_names[0])
          workout_details << exercise_names 
          workout_stats["#{prev_workout.workout_group.name}"] = [workout_details.flatten]
        end
        workout_stats["#{prev_workout.workout_group.name}"] <<
            [prev_workout.workout_date.strftime('%m/%d/%y'),
             prev_workout.workout_details.map { |detail| detail.max_rep_weight }].flatten
      end
    end

    workout_stats
	end
end
