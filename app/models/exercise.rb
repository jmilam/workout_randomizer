class Exercise < ApplicationRecord
  belongs_to :workout_group
  has_many :workout_details

  validates :name, presence: true

  def self.to_word(boolean)
    boolean ? 'Yes' : 'No'
  end

  def self.group_super_sets(workout_group)
    exercise_groups = workout_group.exercises
      .sort_by { |exercise| exercise.priority.nil? ? 9999 : exercise.priority }
      .group_by(&:super_set_id)

    unless exercise_groups[nil].nil?
      exercise_groups[nil].each do |nil_group|
        exercise_groups["#{nil_group.id}a"] = [nil_group]
      end
     end

    exercise_groups.delete(nil)
    exercise_groups
  end

  def self.get_exercise(user, exercise_groups)
    exercises_completed = WorkoutDetail.where(workout_date: Date.today.strftime('%Y-%m-%d'), user_id: user.id).map(&:exercise_id)

    exercise_ids = exercise_groups.values.flatten.map(&:id).delete_if { |exercise_id| exercises_completed.include?(exercise_id) }

    exercise_groups.each do |_group, group_exercises|
      group_exercise = group_exercises.delete_if { |group_exercise| !exercise_ids.include?(group_exercise.id) }
    end

    exercise_groups.delete_if { |_key, value| value.empty? }

    if exercise_groups.empty?
      workout_group = WorkoutGroup.find(user.current_workout_group)

      return if workout_group.ab_workout.nil?

      exercises = Workout.find(workout_group.ab_workout)
        .workout_groups
        .sample.exercises.map(&:id)
        .delete_if { |exercise_id| p exercises_completed.include?(exercise_id) }

    else
      exercise_groups.first[1]
    end
  end
end
