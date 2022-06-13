class SystemParametrization < ApplicationRecord
  VALID_SIGN_ATTRIBUTES = %w[email document cellphone nickname]

  serialize :sign_in_attributes, Array

  validates :registration_attribute, inclusion: { in: proc { |a| a.sign_in_attributes } }
  validate :sign_in_attributes_values

  def self.current
    last || create_default!
  end

  private

  def self.create_default!
    SystemParametrization.create!(registration_attribute: 'email',
                                  sign_in_attributes: %w[email nickname document cellphone],
                                  user_confirmable_on_register: false,
                                  user_confirmed_for_withdraw_mandatory: true,
                                  mandatory_register_with_sponsor_token: true,
                                  pay_direct_indication_bonus: true,
                                  pay_indirect_indication_bonus: true,
                                  pay_residual_bonus: true,
                                  compliance_on_withdrawal_mandatory: true,
                                  current_withdraw_parametrization_ids: nil,
                                  current_deposit_parametrization_ids: nil,
                                  seconds_to_expire_session: 300,
                                  seconds_to_expire_reset_password_token: 300)
  end

  def sign_in_attributes_values
    return if sign_in_attributes && sign_in_attributes.all? {|a| a.in?(VALID_SIGN_ATTRIBUTES) }

    errors.add(:sign_in_attributes, :invalid)
  end
end
