FactoryBot.define do
  factory :withdraw do
    association :user
    association :currency
    association :receivable_method, factory: :pix
    gross_amount { Faker::Number.number(digits: 5) }
    net_amount { Faker::Number.number(digits: 5) }
    receivable_currency_amount { Faker::Number.number(digits: 5) }
    status { Withdraw::statuses.keys.sample }
    confirmation_token { SecureRandom.hex }
  end
end
