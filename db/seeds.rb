# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

gym = Gym.create(name: "Boomslang Fitness", phone_number: "336-707-7939")

user = User.create_with(height: 68, weight: 173, phone_number: "336-707-7939",
												regularity_id: 5, goal_id: 1, email: "jasonlmilam@gmail.com",
												pin: 1011, gym: gym.id)
					 .find_or_create_by(first_name: "Jason", last_name: "Milam")

gym.update(admin_ids: "#{user.id}")