class CreateBankAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :bank_accounts do |t|
      t.string :bank_name
      t.integer :kind
      t.string :agency
      t.string :number
      t.string :digit
      t.boolean :active, default: true
      t.references :currency
    end
  end
end
