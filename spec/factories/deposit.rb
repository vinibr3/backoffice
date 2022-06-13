FactoryBot.define do
  factory :deposit do
    association :user
    association :currency
    association :payment_transaction
    amount { Faker::Number.number(digits: 5) }
  end
end
