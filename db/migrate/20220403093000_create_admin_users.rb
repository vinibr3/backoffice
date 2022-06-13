class CreateAdminUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :admin_users do |t|
      t.string :email
      t.string :name
      t.integer :gender, limit: 2
      t.string :phone
      t.string :document
      t.datetime :birthdate
      t.boolean :active, default: true
    end
  end
end
