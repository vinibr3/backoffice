class CreateBonusCommissions < ActiveRecord::Migration[6.0]
  def change
    create_table :bonus_commissions do |t|
      t.integer :generation
      t.float :percentage
      t.references :financial_reason
      t.references :product
    end
  end
end
