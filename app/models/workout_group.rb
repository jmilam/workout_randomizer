class WorkoutGroup < ApplicationRecord
  belongs_to :workout
  has_many :exercises, dependent: :destroy
  has_many :workout_details
end
