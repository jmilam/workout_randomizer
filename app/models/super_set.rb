class SuperSet < ApplicationRecord
  def update_superset(exercise_id, super_set_exercise_id)
    [exercise_one_id, exercise_two_id].each do |exercise_id|
      exercise = Exercise.find_by(id: exercise_id)

      next if exercise.nil?

      exercise.update(super_set_id: nil)
    end

    delete

    SuperSet.create(exercise_one_id: exercise_id, exercise_two_id: super_set_exercise_id)
    self
  end

  def self.create_or_update(exercise, super_set_id)
    set = SuperSet.find_by(id: exercise.super_set_id)

    if exercise.super_set_id.nil? || set.nil?
      SuperSet.create(exercise_one_id: exercise.id, exercise_two_id: super_set_id)
    else
      set.update_superset(exercise.id, super_set_id)
    end
  end

  def self.get_shared_exercise(exercise)
    superset = SuperSet.find_by(id: exercise.super_set_id)
    superset.nil? ? 0 : [superset.exercise_one_id, superset.exercise_two_id].delete_if { |id| id == exercise.id }[0]
  end
end
