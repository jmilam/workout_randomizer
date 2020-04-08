FactoryBot.define do
  factory :workout_detail do
    exercise
    user_previous_workout
    rep_1_weight Faker::Number.within(range: 1..10)
  end
end
