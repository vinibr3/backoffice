FactoryBot.define do
  factory :address do
    association :addressable, factory: :user
    zipcode { Faker::Address.zip_code }
    street { Faker::Address.street_name }
    number { Faker::Number.number(digits: 5) }
    complement { Faker::Address.street_address }
    district { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state }
    country { Faker::Address.country }
  end
end
