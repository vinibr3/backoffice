FactoryBot.define do
  factory :item do
    association :order
    association :product
    quantity { Faker::Number.number(digits: 5) }
    unit_price { Faker::Number.number(digits: 5) }
    total_price { Faker::Number.number(digits: 5) }
  end
end
