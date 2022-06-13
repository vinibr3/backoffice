class AddTimestampsToPixes < ActiveRecord::Migration[6.0]
  def change
    add_timestamps :pixes
    add_timestamps :withdraws
    add_timestamps :wallets
    add_timestamps :bank_accounts
  end
end
