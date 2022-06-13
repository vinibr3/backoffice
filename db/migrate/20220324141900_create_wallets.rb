class CreateWallets < ActiveRecord::Migration[6.0]
  def change
    create_table :wallets do |t|
      t.string :secret_hash
      t.boolean :active, default: true
      t.references :currency
      t.references :user
    end
  end
end
