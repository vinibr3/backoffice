class CreateCategory < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      t.string :name, default: ''
      t.boolean :active, default: true
      t.integer :code, index: true
      t.timestamps
    end
  end
end
