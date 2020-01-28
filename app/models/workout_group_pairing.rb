class WorkoutGroupPairing < ApplicationRecord
  belongs_to :workout
  belongs_to :workout_group
  belongs_to :gym
end
