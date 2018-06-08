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
      p workout_name = WorkoutGroup.find(previous_workout[0]).workout.name
      workout_details = ['Date']
      previous_workout[1].each do |prev_workout|
        exercises = prev_workout.exercises.sort
        exercise_names = exercises.map(&:name)
        exercise_ids = exercises.map(&:id)

        if workout_stats["#{workout_name}"].nil?
          workout_stats["#{workout_name}"] = {}
        elsif workout_stats["#{workout_name}"]["#{prev_workout.workout_group.name}"].nil? || workout_stats["#{workout_name}"]["#{prev_workout.workout_group.name}"].include?(exercise_names[0])
          workout_details << exercise_names 
          workout_stats["#{workout_name}"]["#{prev_workout.workout_group.name}"] = [workout_details.flatten]
          workout_stats["#{workout_name}"]["#{prev_workout.workout_group.name}"] <<
            [prev_workout.workout_date.strftime('%m/%d/%y'), self.build_max_reps(prev_workout.workout_details, exercise_ids)].flatten
        end
      end
    end

    workout_stats
	end

  def self.build_max_reps(details, exercise_ids)
    max_reps = Array.new(exercise_ids.count)
    
    detail_exercise_ids = details.map(&:exercise_id).sort

    exercise_ids.each_with_index do |id, idx|
      if !detail_exercise_ids.include?(id)
        max_reps[idx] = 0
      end
    end

    details.each do |detail|
      idx = exercise_ids.index(detail.exercise_id)
      max_reps[idx] = detail.max_rep_weight
    end
    max_reps
  end

end
