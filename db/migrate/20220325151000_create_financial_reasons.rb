class CreateFinancialReasons < ActiveRecord::Migration[6.0]
  def change
    create_table :financial_reasons do |t|
      t.string :title
      t.integer :code, index: true
      t.boolean :active, default: true
    end
  end
end
