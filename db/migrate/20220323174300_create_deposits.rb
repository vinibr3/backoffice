class CreateDeposits < ActiveRecord::Migration[6.0]
  def change
    create_table :deposits do |t|
      t.references :user
      t.integer :amount, limit: 8
      t.references :currency
      t.references :payment_transaction
    end
  end
end
