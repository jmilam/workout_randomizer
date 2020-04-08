FactoryBot.define do
  factory :gym do
    name Faker::Name.name
    address '1 Average ln.'
    city 'Rotterdam'
    state 'NY'
    zipcode '12306'
    phone_number  '1234567890'
  end
end
