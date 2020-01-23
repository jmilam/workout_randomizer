class Exercise < ApplicationRecord
  belongs_to :workout
  belongs_to :common_exercise 
  has_many :workout_details
  has_one_attached :clip

  def self.to_word(boolean)
    boolean ? 'Yes' : 'No'
  end

  def self.group_by_circuit(workout)
    exercise_groups = workout.exercises
      .sort_by { |exercise| exercise.priority.nil? ? 9999 : exercise.priority }
      .group_by(&:exercise_circuit_id)

    unless exercise_groups[nil].nil?
      exercise_groups[nil].each do |nil_group|
        exercise_groups["#{nil_group.id}a"] = [nil_group]
      end
     end

    exercise_groups.delete(nil)
    exercise_groups
  end

  def self.get_exercise(user, exercise_groups, workout_date=Date.today.strftime('%Y-%m-%d'))
    exercises_completed = WorkoutDetail.where(workout_date: workout_date, user_id: user.id).map(&:exercise_id)

    exercise_ids = exercise_groups.values.flatten.map(&:id).delete_if { |exercise_id| exercises_completed.include?(exercise_id) }

    exercise_groups.each do |_group, group_exercises|
      group_exercise = group_exercises.delete_if { |group_exercise| !exercise_ids.include?(group_exercise.id) }
    end

    exercise_groups.delete_if { |_key, value| value.empty? }

    if exercise_groups.empty?
      user.update(current_workout_group: nil)
      exercise_groups
    else
      exercise_groups.first[1]
    end
  end
end
