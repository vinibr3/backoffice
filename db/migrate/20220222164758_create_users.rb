class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email, index: true, default: '', null: false
      t.string :password_digest, null: false
      t.datetime :terms_of_service_accepted_at
      t.inet :terms_of_service_accepted_ip
      t.string :name, default: ''
      t.string :nickname, default: '', index: true
      t.integer :gender, limit: 2
      t.string :document, index: true, default: ''
      t.date :birthdate
      t.datetime :active_until_at
      t.string :cellphone, index: true, default: ''
      t.string :facebook, default: ''
      t.string :instagram, default: ''
      t.string :twitter, default: ''
      t.string :sponsor_token, default: '', index: true
      t.datetime :sent_to_compliance_at
      t.datetime :compliance_at
      t.integer :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet :current_sign_in_ip
      t.inet :last_sign_in_ip
      t.string :provider, default: '', null: false
      t.string :uid, default: '', index: true
      t.string :reset_password_token, default: '', index: true
      t.datetime :reset_password_token_sent_at
      t.string :confirmation_token, default: '', index: true
      t.datetime :confirmed_at
      t.datetime :confirmation_token_sent_at

      t.timestamps
    end
  end
end
