class WorkoutGroupSpecifiedDay < ApplicationRecord
	belongs_to :workout_group
	scope :present_for_workout_group, -> (workout_group_id, day_of_the_week) { where(workout_group_id: workout_group_id, workout_day_num: day_of_the_week)}
end
