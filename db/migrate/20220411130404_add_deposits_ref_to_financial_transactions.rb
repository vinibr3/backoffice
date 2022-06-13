class AddDepositsRefToFinancialTransactions < ActiveRecord::Migration[6.0]
  def change
    add_reference :financial_transactions, :deposit, null: true, foreign_key: true
  end
end
