FactoryBot.define do
  factory :system_parametrization do
    sign_in_attributes = %w[email nickname document cellphone].sample((1..4).to_a.sample)

    sign_in_attributes { sign_in_attributes }
    registration_attribute { sign_in_attributes.sample }
    user_confirmable_on_register { Faker::Boolean.boolean }
    user_confirmed_for_withdraw_mandatory { Faker::Boolean.boolean }
    mandatory_register_with_sponsor_token { Faker::Boolean.boolean }
    pay_direct_indication_bonus { Faker::Boolean }
    pay_indirect_indication_bonus { Faker::Boolean.boolean }
    pay_residual_bonus { Faker::Boolean.boolean }
    compliance_on_withdrawal_mandatory { Faker::Boolean.boolean }
    current_withdraw_parametrization_ids { nil }
    current_deposit_parametrization_ids { nil }
    seconds_to_expire_session { Faker::Number.positive.to_i }

    trait :with_valid_sign_attributes do
      sign_in_attributes = %w[email nickname document cellphone].sample((1..4).to_a.sample)

      sign_in_attributes { sign_in_attributes }
      registration_attribute { sign_in_attributes.sample }
    end

    trait :with_invalid_sign_attributes do
      sign_in_attributes { Faker::Types.rb_array }
    end
  end
end
