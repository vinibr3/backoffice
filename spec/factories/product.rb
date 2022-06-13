FactoryBot.define do
  factory :product do
    association :category
    price { Faker::Number.number(digits: 5) }
    name { Faker::Name.name }
    description { Faker::Lorem.sentences }
    code { Faker::Number.number(digits: 5) }
    profile { association(:profile) }
  end
end
