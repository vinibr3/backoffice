FactoryBot.define do
  factory :rule do
    code { Faker::Number.positive }
    description { Faker::Lorem.sentences }
    name { Faker::Name.name }
  end
end
