class CreateRules < ActiveRecord::Migration[6.0]
  def change
    create_table :rules do |t|
      t.integer :code
      t.text :description
      t.string :name
    end
  end
end
