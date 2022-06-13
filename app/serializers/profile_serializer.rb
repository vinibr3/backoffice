# frozen_string_literal: true

class ProfileSerializer < JSONAPI::Serializable::Resource
  type 'profiles'

  attributes :name, :trade_fee_percentage, :duration_days_per_purchase,
             :duration_days_per_monthly_result, :monthly_qualification_amount,
             :active
end
