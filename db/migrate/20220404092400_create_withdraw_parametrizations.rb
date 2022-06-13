class CreateWithdrawParametrizations < ActiveRecord::Migration[6.0]
  def change
    create_table :withdraw_parametrizations do |t|
      t.integer :minimum_amount, limit: 8
      t.integer :maximum_amount, limit: 8
      t.references :currency
      t.timestamps
    end
  end
end
