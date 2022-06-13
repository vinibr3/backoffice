# frozen_string_literal: true

class UserSerializer < JSONAPI::Serializable::Resource
  type 'users'

  attributes :email, :terms_of_service_accepted_at, :terms_of_service_accepted_ip,
             :name, :nickname, :gender, :document, :birthdate, :active_until_at,
            :cellphone, :facebook, :instagram, :twitter, :sponsor_token,
            :sent_to_compliance_at, :compliance_at, :sign_in_count, :current_sign_in_at,
            :current_sign_in_ip, :last_sign_in_ip, :provider, :confirmed_at,
            :confirmation_token_sent_at, :created_at, :updated_at, :sponsoreds_count,
            :active_sponsoreds_count

  belongs_to :profile

  has_one :unilevel_node
  has_one :address

  has_many :bank_accounts
  has_many :pixes
  has_many :wallets

  attribute :sponsoreds_count do
    @object.sponsoreds.count
  end

  attribute :active_sponsoreds_count do
    @object.sponsoreds.active.count
  end
end
