FactoryBot.define do
  factory :payment_method do
    association :currency
    name { Faker::Name.name }
    code { Faker::Number.positive }

    trait :with_valid_code do
      code { PaymentMethod::VALID_CODES.values.sample }
    end
  end
end
