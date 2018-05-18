FactoryBot.define do
  factory :user do
    gym
    first_name 'Peter'
    last_name 'La Fleur'
    height        68
    weight        175
    phone_number  '1234567890'
    email 'plafleur@gmail.com'
    username 'plafleur'
    password 'dodgeball'
    regularity_id 1
    goal_id 1
  end
end
