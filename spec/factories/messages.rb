FactoryBot.define do
  factory :message do
    detail { Faker::TvShows::NewGirl.quote }
  end
end
