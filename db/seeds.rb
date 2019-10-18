# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
gym = Gym.create!(name: "Boomslang Fitness", phone_number: "336-707-7939")
gym.categories.create!(name: "Lean Muscle Gain", goal_id: User.goals.keys[1])
lose_weight = gym.categories.create!(name: "Lose Weight", goal_id: User.goals.keys[0])

["Boxing", "Martial Arts", "Group Class"].each do |class_name|
  workout = gym.workouts.create!(name: class_name, category_id: lose_weight.id, frequency: 0)
  workout_group = workout.workout_groups.create!(name: "#{class_name} Workouts")
  workout_group.exercises.create!(name: "#{class_name} Exercises",
                                  timed_exercise: true,
                                  time_by_minutes: 45)
end