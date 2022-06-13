# frozen_string_literal: true

class SystemParametrizationSerializer < JSONAPI::Serializable::Resource
  type 'system_parametrizations'

  attributes :registration_attribute, :sign_in_attributes, :user_confirmable_on_register,
             :seconds_to_expire_reset_password_token, :user_confirmed_for_withdraw_mandatory,
             :mandatory_register_with_sponsor_token, :pay_direct_indication_bonus,
             :pay_indirect_indication_bonus, :pay_residual_bonus,
             :compliance_on_withdrawal_mandatory, :current_withdraw_parametrization_ids,
             :current_deposit_parametrization_ids, :seconds_to_expire_session,
             :seconds_to_expire_confirmation_token
end
