class UserPreviousWorkout < ApplicationRecord
  belongs_to :user
  belongs_to :workout

  has_many :exercises, through: :workout
  has_many :workout_details

  validates :workout_date, presence: true
  validates :workout_id, presence: true

  def self.for_google_charts(grouped_workouts)
    workout_stats = {}

    grouped_workouts.each do |previous_workout, previous_workout_details|
      workout_name = previous_workout.name
      workout_details = ['Date']
      previous_workout_details.sort_by(&:user_previous_workout).group_by do |detail|
        detail.user_previous_workout.workout_date
      end.each do |workout_date, prev_workout_details|
          exercise_ids = nil
          prev_workout_details.each do |prev_workout_detail|
            exercises = prev_workout_detail.user_previous_workout.workout.exercises.sort
            exercise_names = exercises.map { |exercise| exercise.common_exercise.name }
            exercise_ids = exercises.map(&:id)

            workout_details << exercise_names

            if workout_stats[workout_name.to_s].nil?
              workout_stats[workout_name.to_s] = {}
              workout_stats[workout_name.to_s] = [workout_details.flatten]
            elsif workout_stats[workout_name.to_s].nil? || workout_stats[workout_name.to_s].include?(exercise_names[0])
              workout_stats[workout_name.to_s] = [workout_details.flatten]
            end
          end

          workout_stats[workout_name.to_s] <<
              [workout_date.strftime('%m/%d/%y'), build_max_reps(prev_workout_details, exercise_ids)].flatten
      end
    end

    workout_stats
  end

  def self.build_max_reps(details, exercise_ids)
    max_reps = Array.new(exercise_ids.count)

    exercise_ids.each_with_index do |id, idx|
      max_reps[idx] = 0
    end
    
    p exercise_ids
    details.each_with_index do |detail, idx|
      p detail
      p idx
      p idx = exercise_ids.index(detail.exercise_id)
      next if idx.nil?

      max_reps[idx] = detail.avg_rep_weight
    end

    max_reps
  end
end
