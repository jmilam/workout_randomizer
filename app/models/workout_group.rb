class WorkoutGroup < ApplicationRecord
  belongs_to :workout
  has_many :exercises, dependent: :destroy
  has_many :workout_group_specified_days
  has_many :workout_details
  has_many :wods

  enum day_of_the_week: {
    1 => 'Sunday',
    2 => 'Monday',
    3 => 'Tuesday',
    4 => 'Wednesday',
    5 => 'Thursday',
    6 => 'Friday',
    7 => 'Saturday'
  }
end
