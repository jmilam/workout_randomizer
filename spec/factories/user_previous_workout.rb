FactoryBot.define do
  factory :user_previous_workout do
    user
    workout
    workout_date Date.today - 1.day
  end
end
