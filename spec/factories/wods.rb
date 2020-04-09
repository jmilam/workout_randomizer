FactoryBot.define do
  factory :wod do
    workout
    gym
    workout_date { Date.today }
  end
end
