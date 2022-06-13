FactoryBot.define do
  factory :rule_ruleable do
    association :rule
    association :admin_user
    association :ruleable, factory: :admin_user
    inactive_at { Faker::Date.between(from: 5.years.ago, to: 5.year.from_now) }
    inactivator_id { Faker::Number.positive }
  end
end
