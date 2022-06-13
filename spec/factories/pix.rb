FactoryBot.define do
  factory :pix do
    association :currency
    association :user
    secret_key { Faker::Alphanumeric.alpha(number: 5) }
    kind { %w[detached document cellphone email].sample }
  end
end
