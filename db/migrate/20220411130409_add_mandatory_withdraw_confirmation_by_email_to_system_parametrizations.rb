class AddMandatoryWithdrawConfirmationByEmailToSystemParametrizations < ActiveRecord::Migration[6.0]
  def change
    add_column :system_parametrizations, :mandatory_withdraw_confirmation_by_email, :boolean, default: true
  end
end
