FactoryBot.define do
  factory :user_profile do
    association :user
    association :profile
    expire_at { Faker::Time.forward(days: 23, period: :morning) }
  end
end
