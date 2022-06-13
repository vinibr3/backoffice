FactoryBot.define do
  factory :payment_transaction do
    association :payable, factory: :order
    association :payment_method
    transaction_code { Faker::Alphanumeric.alpha(number: 5) }
    amount { Faker::Number.number(digits: 5) }
    creation_response { Faker::Alphanumeric.alpha(number: 5) }
    notification_response { Faker::Alphanumeric.alpha(number: 5) }
    digital_address { Faker::Alphanumeric.alpha(number: 5) }
    qr_code_base64 { Faker::Alphanumeric.alpha(number: 5) }
    status { PaymentTransaction::statuses.keys.sample }

    trait :with_status_unpaid do
      paid_at { nil }
      status { :unpaid }
      notification_response { nil }
    end
  end
end
