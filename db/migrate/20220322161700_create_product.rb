class CreateProduct < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.references :profile
      t.references :category
      t.integer :price, limit: 8
      t.string :name, default: ''
      t.text :description, default: ''
      t.boolean :active, default: true
      t.integer :code, index: true
      t.timestamps
    end
  end
end
