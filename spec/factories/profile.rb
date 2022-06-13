FactoryBot.define do
  factory :profile do
    name { Faker::Name.name }
    trade_fee_percentage { Faker::Number.number(digits: 5) }
    duration_days_per_purchase { Faker::Number.number(digits: 5) }
    duration_days_per_monthly_result { Faker::Number.number(digits: 5) }
    monthly_qualification_amount { Faker::Number.number(digits: 5) }
  end
end
