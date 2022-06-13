FactoryBot.define do
  factory :financial_transaction do
    association :user
    association :financial_reason
    association :currency
    association :bonus_commission
    association :product
    association :spreader_user, factory: :user
    note { Faker::Lorem.sentence }
    user_amount { Faker::Number.number(digits: 5) }
    admin_amount { Faker::Number.number(digits: 5) }
    system_amount { Faker::Number.number(digits: 5) }
    admin_cashflow { %w[not_applicable in out].sample }
    system_cashflow { %w[not_applicable in out].sample }
    user_cashflow { %w[not_applicable in out].sample }
    financial_result_code { Faker::Number.number(digits: 5) }
  end
end
