# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
Gym.create(name: "Boomslang Fitness", phone_number: "336-707-7939")
Category.create(name: "Lean Muscle Gain", goal_id: User.goals.keys[1])