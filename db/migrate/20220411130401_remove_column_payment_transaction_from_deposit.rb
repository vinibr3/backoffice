class RemoveColumnPaymentTransactionFromDeposit < ActiveRecord::Migration[6.0]
  def change
    remove_column :deposits, :payment_transaction_id
  end
end
