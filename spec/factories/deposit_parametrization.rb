FactoryBot.define do
  factory :deposit_parametrization do
    association :currency
    a = Faker::Number.positive
    minimum_amount { a }
    maximum_amount { a + Faker::Number.positive }
  end
end
