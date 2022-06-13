class AddForeignKeyToFinancialTransaction < ActiveRecord::Migration[6.0]
  def change
    add_reference :financial_transactions, :withdraw
  end
end
