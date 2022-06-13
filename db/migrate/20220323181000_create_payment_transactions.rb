class CreatePaymentTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :payment_transactions do |t|
      t.references :payable, polymorphic: true
      t.references :payment_method
      t.integer :status, limit: 2
      t.string :transaction_code, index: true
      t.integer :amount, limit: 8
      t.jsonb :creation_response
      t.datetime :paid_at
      t.jsonb :notification_response
      t.text :digital_address, default: ''
      t.text :qr_code_base64, default: ''

      t.timestamps
    end
  end
end
