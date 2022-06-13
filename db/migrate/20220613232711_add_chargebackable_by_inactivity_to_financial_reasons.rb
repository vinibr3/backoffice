class AddChargebackableByInactivityToFinancialReasons < ActiveRecord::Migration[6.0]
  def change
    add_column :financial_reasons, :chargebackable_by_inactivity, :boolean, default: true
  end
end
