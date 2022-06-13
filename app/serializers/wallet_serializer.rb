# frozen_string_literal: true

class WalletSerializer < JSONAPI::Serializable::Resource
  type 'wallets'

  attributes :secret_hash, :created_at, :updated_at

  belongs_to :user
  belongs_to :currency

  has_many :withdraws
end
