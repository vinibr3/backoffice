class CreateFinancialTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :financial_transactions do |t|
      t.references :user
      t.references :spreader_user
      t.references :order
      t.references :financial_reason
      t.references :currency
      t.references :bonus_commission
      t.text :note, defaul: ''
      t.integer :user_amount, default: 0
      t.integer :admin_amount, default: 0
      t.integer :system_amount, default: 0
      t.integer :admin_cashflow
      t.integer :system_cashflow, default: 0
      t.integer :user_cashflow
      t.integer :financial_result_code, index: true

      t.timestamps
    end
  end
end
