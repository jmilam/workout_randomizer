FactoryBot.define do
  factory :workout do
    gym
    category
    name { Faker::Superhero.descriptor }
    frequency { Faker::Number.within(range: 1..10) }
    duration { Faker::Number.within(range: 1..10) }
  end
end
