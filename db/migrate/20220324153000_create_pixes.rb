class CreatePixes < ActiveRecord::Migration[6.0]
  def change
    create_table :pixes do |t|
      t.string :secret_key
      t.integer :kind
      t.boolean :active, default: true
      t.references :currency
    end
  end
end
