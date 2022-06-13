class AddComplianceAdminUserIdToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :compliance_admin_user_id, :integer
    add_index :users, :compliance_admin_user_id
  end
end
