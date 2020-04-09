FactoryBot.define do
  factory :user do
    gym
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    height        68
    weight        175
    phone_number  { Faker::PhoneNumber.cell_phone }
    email { Faker::Internet.email }
    password 'dodgeball'
    regularity_id 1
    goal_id 1
    not_a_robot true
  end
end
