FactoryBot.define do
  factory :gym do
    name { Faker::Name.name }
    address { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state }
    zipcode { Faker::Address.zip_code }
    phone_number  { Faker::PhoneNumber.cell_phone }
  end
end
