FactoryBot.define do
  factory :order do
    association :user
    association :currency
    subtotal { Faker::Number.positive }
    total { Faker::Number.positive }
    expire_at { Faker::Time.forward(days: 23, period: :morning) }

    factory :order_with_items do
      transient do
        items_count { 10 }
      end

      after(:create) do |order, evaluator|
        create_list(:item, evaluator.items_count, order: order)
      end
    end
  end
end
