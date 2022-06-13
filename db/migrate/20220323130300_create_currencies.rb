class CreateCurrencies < ActiveRecord::Migration[6.0]
  def change
    create_table :currencies do |t|
      t.string :name
      t.string :initials
      t.integer :scale, limit: 2
      t.boolean :crypto, default: false
      t.boolean :active, default: true
      t.boolean :order_payment_enabled, default: true
      t.boolean :deposit_payment_enabled, default: true
      t.boolean :withdraw_enable, default: true
      t.boolean :receivable_method_enabled, default: true

      t.timestamps
    end
  end
end
