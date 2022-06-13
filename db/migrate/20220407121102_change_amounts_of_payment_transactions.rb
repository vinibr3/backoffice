class ChangeAmountsOfPaymentTransactions < ActiveRecord::Migration[6.0]
  def change
    change_column :financial_transactions, :user_amount, :integer, limit: 8, default: 0
    change_column :financial_transactions, :admin_amount, :integer, limit: 8, default: 0
    change_column :financial_transactions, :system_amount, :integer, limit: 8, default: 0
  end
end
