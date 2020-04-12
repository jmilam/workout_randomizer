FactoryBot.define do
  factory :task do
    name { Faker::Job.field }
  end
end
