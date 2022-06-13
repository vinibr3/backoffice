FactoryBot.define do
  factory :user do
    password = Faker::Internet.password(min_length: 6)

    association :admin_user
    email { Faker::Internet.email }
    password { password }
    password_confirmation { password }
    terms_of_service_accepted_at { Faker::Date.backward(days: 14) }
    terms_of_service_accepted_ip { Faker::Internet.ip_v4_address }
    name { Faker::Name.name }
    nickname { Faker::Name.unique.name }
    gender { User::genders.keys.sample }
    document { Faker::IDNumber.valid }
    birthdate { Faker::Date.backward(days: Faker::Number.positive.to_i) }
    active_until_at { [nil, Faker::Date.between(from: 5.years.ago, to: 5.year.from_now)].sample }
    cellphone { Faker::PhoneNumber.cell_phone }
    facebook { Faker::Name.first_name }
    instagram { Faker::Name.last_name }
    twitter { Faker::Name.first_name }
    sponsor_token { SecureRandom.base64 }
    compliance_at { Faker::Date.between(from: 5.years.ago, to: 5.year.from_now) }
    sign_in_count { Faker::Number.positive }
    last_sign_in_at { Faker::Date.between(from: 5.years.ago, to: 5.year.from_now) }
    current_sign_in_ip { Faker::Internet.ip_v4_address }
    last_sign_in_ip { Faker::Internet.ip_v4_address }
    provider { ['email', 'nickname', 'cellphone', 'document'].sample }
    uid { SecureRandom.uuid }
    reset_password_token { SecureRandom.hex }
    reset_password_token_sent_at { Faker::Date.between(from: 5.years.ago, to: 5.year.from_now) }
    confirmation_token { SecureRandom.hex }
    confirmed_at { Faker::Date.between(from: 5.years.ago, to: 5.year.from_now) }
    confirmation_token_sent_at { Faker::Date.between(from: 5.years.ago, to: 5.year.from_now) }

    factory :user_with_deposits do
      after(:create) do |user, evaluator|
        create_list(:deposit, 30, user: user)
      end
    end

    trait :with_terms_of_service_accepted do
      terms_of_service { true }
      terms_of_service_accepted_at { Time.now }
      terms_of_service_accepted_ip { Faker::Internet.ip_v4_address }
    end

    trait :without_terms_of_service_accepted do
      terms_of_service { true }
      terms_of_service_accepted_at { '' }
      terms_of_service_accepted_ip { '' }
    end

    trait :with_valid_confirmation_token do
      confirmation_token { SecureRandom.hex }
      confirmation_token_sent_at { Time.now }
      confirmed_at { nil }
    end
  end
end
