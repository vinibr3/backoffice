FactoryBot.define do
  factory :bonus_commission do
    association :financial_reason
    generation { Faker::Number.number(digits: 5) }
    percentage { Faker::Number.decimal(l_digits: 2) }
  end
end
