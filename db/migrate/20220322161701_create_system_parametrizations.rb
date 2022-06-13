class CreateSystemParametrizations < ActiveRecord::Migration[6.0]
  def change
    create_table :system_parametrizations do |t|
      t.string :registration_attribute, default: 'email'
      t.text :sign_in_attributes
      t.boolean :user_confirmable_on_register, default: false
      t.boolean :user_confirmed_for_withdraw_mandatory, default: true
      t.boolean :mandatory_register_with_sponsor_token, defaul: true
      t.boolean :pay_direct_indication_bonus, default: true
      t.boolean :pay_indirect_indication_bonus, default: true
      t.boolean :pay_residual_bonus, default: true
      t.boolean :compliance_on_withdrawal_mandatory, default: true
      t.text :current_withdraw_parametrization_ids
      t.text :current_deposit_parametrization_ids
      t.integer :seconds_to_expire_session, default: 300

      t.timestamps
    end
  end
end
