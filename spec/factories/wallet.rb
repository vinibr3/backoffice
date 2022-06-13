FactoryBot.define do
  factory :wallet do
    association :currency
    association :user
    secret_hash { Faker::Alphanumeric.alpha(number: 5) }
  end
end
