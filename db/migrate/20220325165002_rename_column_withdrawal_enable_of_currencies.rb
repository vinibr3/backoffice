class RenameColumnWithdrawalEnableOfCurrencies < ActiveRecord::Migration[6.0]
  def change
    rename_column :currencies, :withdraw_enable, :withdraw_enabled
  end
end
