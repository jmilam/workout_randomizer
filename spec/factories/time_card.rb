FactoryBot.define do
  factory :time_card do
    task
    user
    start_time { Time.now - 30.minutes }
    end_time { Time.now }
  end
end
