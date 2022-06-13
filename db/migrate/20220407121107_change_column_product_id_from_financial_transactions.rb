class ChangeColumnProductIdFromFinancialTransactions < ActiveRecord::Migration[6.0]
  def change
    change_column :financial_transactions, :product_id, :integer, null: true
  end
end
