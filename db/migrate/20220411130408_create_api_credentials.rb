class CreateApiCredentials < ActiveRecord::Migration[6.0]
  def change
    create_table :api_credentials do |t|
      t.references :user
      t.text :key, default: ''
      t.text :secret, default: ''

      t.timestamps
    end
  end
end
