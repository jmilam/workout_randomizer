FactoryBot.define do
  factory :exercise do
    common_exercise
    common_equipment
    workout
    rep_range '10-12'
  end
end
