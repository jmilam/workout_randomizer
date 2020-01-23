class UserPreviousWorkout < ApplicationRecord
  belongs_to :user
  belongs_to :workout

  has_many :exercises, through: :workout
  has_many :workout_details

  validates :workout_date, presence: true
  validates :workout_id, presence: true

  def self.for_google_charts(grouped_workouts)
    workout_stats = {}

    grouped_workouts.each do |previous_workout|
      workout_name = WorkoutGroup.find(previous_workout[0]).workout.name
      workout_details = ['Date']
      previous_workout[1].each do |prev_workout|
        exercises = prev_workout.exercises.sort
        exercise_names = exercises.map(&:name)
        exercise_ids = exercises.map(&:id)

        workout_details << exercise_names

        if workout_stats[workout_name.to_s].nil?
          workout_stats[workout_name.to_s] = {}
          workout_stats[workout_name.to_s][prev_workout.workout_group.name.to_s] = [workout_details.flatten]
        elsif workout_stats[workout_name.to_s][prev_workout.workout_group.name.to_s].nil? || workout_stats[workout_name.to_s][prev_workout.workout_group.name.to_s].include?(exercise_names[0])
          workout_stats[workout_name.to_s][prev_workout.workout_group.name.to_s] = [workout_details.flatten]
        end

        workout_stats[workout_name.to_s][prev_workout.workout_group.name.to_s] <<
          [prev_workout.workout_date.strftime('%m/%d/%y'), build_max_reps(prev_workout.workout_details, exercise_ids)].flatten
      end
    end

    workout_stats
  end

  def self.build_max_reps(details, exercise_ids)
    max_reps = Array.new(exercise_ids.count)

    detail_exercise_ids = details.map(&:exercise_id).sort

    exercise_ids.each_with_index do |id, idx|
      max_reps[idx] = 0 unless detail_exercise_ids.include?(id)
    end

    details.each do |detail|
      idx = exercise_ids.index(detail.exercise_id)
      max_reps[idx] = detail.avg_rep_weight
    end
    max_reps
  end
end
