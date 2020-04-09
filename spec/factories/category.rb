FactoryBot.define do
  factory :category do
    gym
    name { Faker::Restaurant.type }
    tag 1
    goal_id 1
  end
end
