FactoryBot.define do
  factory :exercise do
    common_exercise
    common_equipment
    name 'Weighted Ball Throw'
    rep_range '10-12'
  end
end
