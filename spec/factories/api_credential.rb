FactoryBot.define do
  factory :api_credential do
    association :user
    key { SecureRandom.base64(1000) }
    secret { SecureRandom.base64(1000) }
  end
end
