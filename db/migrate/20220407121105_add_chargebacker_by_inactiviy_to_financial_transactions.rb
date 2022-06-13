class AddChargebackerByInactiviyToFinancialTransactions < ActiveRecord::Migration[6.0]
  def change
    add_reference :financial_transactions, :chargebacker_by_inactivity, foreign_key: { to_table: 'financial_transactions' }
  end
end
