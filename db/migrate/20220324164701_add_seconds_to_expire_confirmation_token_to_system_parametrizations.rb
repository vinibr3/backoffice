class AddSecondsToExpireConfirmationTokenToSystemParametrizations < ActiveRecord::Migration[6.0]
  def change
    add_column :system_parametrizations, :seconds_to_expire_confirmation_token, :integer, default: 300
  end
end
