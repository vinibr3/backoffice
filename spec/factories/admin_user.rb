FactoryBot.define do
  factory :admin_user do
    email { Faker::Internet.email }
    name { Faker::Name.name }
    gender { %w[male female].sample }
    phone { Faker::Number.number(digits: 5) }
    document { Faker::Alphanumeric.alpha(number: 5) }
  end
end
