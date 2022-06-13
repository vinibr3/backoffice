class CreateProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :profiles do |t|
      t.string :name
      t.float :trade_fee_percentage
      t.integer :duration_days_per_purchase
      t.integer :duration_days_per_monthly_result
      t.integer :monthly_qualification_amount
      t.boolean :active, default: true
    end
  end
end
