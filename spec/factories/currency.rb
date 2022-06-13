FactoryBot.define do
  factory :currency do
    name { Faker::Name.name }
    initials { SecureRandom.hex }
    scale { Faker::Number.positive.to_i }
    symbol { Faker::Currency.symbol }
    crypto { Faker::Boolean.boolean }
    active { Faker::Boolean.boolean }
    order_payment_enabled { Faker::Boolean.boolean }
    deposit_payment_enabled { Faker::Boolean.boolean }
    withdraw_enabled { Faker::Boolean.boolean }
    receivable_method_enabled { Faker::Boolean.boolean }

    trait :with_faker_initials do
      initials { SecureRandom.hex.first(3) }
    end

    trait :with_valid_initials do
      initials { Currency::INITIALS.values.sample }
    end
  end
end
