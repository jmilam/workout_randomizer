FactoryBot.define do
  factory :common_exercise do
    gym
    name { Faker::Name.name }
  end
end
