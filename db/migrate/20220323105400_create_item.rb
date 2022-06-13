class CreateItem < ActiveRecord::Migration[6.0]
  def change
    create_table :items do |t|
      t.references :order
      t.references :product
      t.integer :quantity
      t.integer :unit_price, limit: 8
      t.integer :total_price, limit: 8

      t.timestamps
    end
  end
end
