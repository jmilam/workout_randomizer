class WorkoutDetail < ApplicationRecord
  belongs_to :exercise
  belongs_to :workout_group
  belongs_to :user
  belongs_to :user_previous_workout

  def max_rep_weight
    [rep_1_weight, rep_2_weight, rep_3_weight, rep_4_weight, rep_5_weight].delete_if(&:nil?).max.to_f
  end

  def avg_rep_weight
    reps = [rep_1_weight, rep_2_weight, rep_3_weight, rep_4_weight, rep_5_weight].delete_if(&:nil?)
    (reps.inject { |sum, el| sum + el }.to_f / reps.count).round(2)
  end
end
