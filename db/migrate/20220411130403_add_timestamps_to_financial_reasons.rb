class AddTimestampsToFinancialReasons < ActiveRecord::Migration[6.0]
  def change
    add_timestamps :financial_reasons
  end
end
