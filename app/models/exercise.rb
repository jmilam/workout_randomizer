class Exercise < ApplicationRecord
  belongs_to :workout
  belongs_to :common_exercise
  belongs_to :common_equipment
  has_many :workout_details

  has_attached_file :video
  validates_attachment_content_type :video, content_type: /\Avideo\/.*\Z/

  def self.to_word(boolean)
    boolean ? 'Yes' : 'No'
  end

  def self.group_by_circuit(workout)
    workout.exercises.sort_by { |exercise| exercise.priority.nil? ? 9999 : exercise.priority }
                    .group_by(&:exercise_circuit_id)
  end

  def self.get_exercise(user, exercise_groups, workout_date=Date.today.strftime('%Y-%m-%d'), manual=false)
    user_previous_workout = UserPreviousWorkout.where(workout_date: workout_date, user_id: user.id)
    exercises_completed = WorkoutDetail.where(user_previous_workout: user_previous_workout).map(&:exercise_id)

    unless manual
      exercise_ids = exercise_groups.values.flatten.map(&:id).delete_if { |exercise_id| exercises_completed.include?(exercise_id) }
      exercise_groups.each do |_group, group_exercises|
        group_exercise = group_exercises.delete_if { |group_exercise| !exercise_ids.include?(group_exercise.id) }
      end
    end

    exercise_groups.delete_if { |_key, value| value.empty? }

    if exercise_groups.empty?
      exercise_groups
    else
      exercise_groups.first[1]
    end
  end
end
