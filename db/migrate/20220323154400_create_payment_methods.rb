class CreatePaymentMethods < ActiveRecord::Migration[6.0]
  def change
    create_table :payment_methods do |t|
      t.string :name
      t.references :currency
      t.boolean :active, default: true
      t.string :code

      t.timestamps
    end
  end
end
