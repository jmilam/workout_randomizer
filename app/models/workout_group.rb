class WorkoutGroup < ApplicationRecord
  has_many :workouts, through: :workoug_group_pairings
  has_many :workout_group_pairings, :dependent => :destroy
  has_many :workout_group_specified_days
  has_many :workout_details
  has_many :wods

  enum day_of_the_week: {
    0 => 'Sunday',
    1 => 'Monday',
    2 => 'Tuesday',
    3 => 'Wednesday',
    4 => 'Thursday',
    5 => 'Friday',
    6 => 'Saturday'
  }
end
