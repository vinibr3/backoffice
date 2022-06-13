class CreateOrder < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.references :user
      t.integer :subtotal, limit: 8
      t.integer :total, limit: 8
      t.datetime :expire_at
      t.references :currency

      t.timestamps
    end
  end
end
