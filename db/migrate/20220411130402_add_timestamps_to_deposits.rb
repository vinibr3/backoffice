class AddTimestampsToDeposits < ActiveRecord::Migration[6.0]
  def change
    add_timestamps :deposits
  end
end
