class CreateDepositParametrizations < ActiveRecord::Migration[6.0]
  def change
    create_table :deposit_parametrizations do |t|
      t.integer :minimum_amount, limit: 8
      t.integer :maximum_amount, limit: 8
      t.references :currency
      t.timestamps
    end
  end
end
