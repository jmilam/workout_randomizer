FactoryBot.define do
  factory :goal do
    comment { Faker::ChuckNorris.fact }
  end
end
