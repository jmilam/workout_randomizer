FactoryBot.define do
  factory :user do
    gym
    first_name 'Peter'
    last_name 'La Fleur'
    height        68
    weight        175
    phone_number  '1234567890'
    email 'plafluer@gmail.com'
    password 'dodgeball'
    regularity_id 1
    goal_id 1
    not_a_robot true
  end
end
