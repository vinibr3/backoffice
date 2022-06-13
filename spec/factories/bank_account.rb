FactoryBot.define do
  factory :bank_account do
    association :currency
    association :user
    bank_name { Faker::Name.name }
    kind { %w[checking savings].sample }
    agency { Faker::Barcode.ean(8) }
    number { Faker::Barcode.ean(8) }
    digit { Faker::Barcode.ean(8) }
  end
end
