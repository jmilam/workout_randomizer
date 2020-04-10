FactoryBot.define do
  factory :message_group do
    subject { Faker::TvShows::NewGirl.character }
  end
end
