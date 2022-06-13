class AddTimestampsToUserProfiles < ActiveRecord::Migration[6.0]
  def change
    add_column :user_profiles, :created_at, :datetime, null: false
    add_column :user_profiles, :updated_at, :datetime, null: false
  end
end
