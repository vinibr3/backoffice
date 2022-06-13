FactoryBot.define do
  factory :financial_reason do
    title { Faker::Name.name }
    code { Faker::Number.number(digits: 5) }

    factory :indirect_indication do
      code { FinancialReason::CODES[:indirect_indication] }
    end
  end
end
