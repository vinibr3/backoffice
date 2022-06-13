class AddProductsRefToFinancialTransactions < ActiveRecord::Migration[6.0]
  def change
    add_reference :financial_transactions, :product, null: false, foreign_key: true
  end
end
