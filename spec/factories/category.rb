FactoryBot.define do
  factory :category do
    name { Faker::Name.name }
    active { Faker::Boolean.boolean }
    code { Faker::Number.number(digits: 5) }
  end
end
