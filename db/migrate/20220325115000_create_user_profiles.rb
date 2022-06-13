class CreateUserProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :user_profiles do |t|
      t.references :user
      t.references :profile
      t.datetime :expire_at
    end
  end
end
