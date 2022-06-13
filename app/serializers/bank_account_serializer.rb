# frozen_string_literal: true

class BankAccountSerializer < JSONAPI::Serializable::Resource
  type 'bank_accounts'

  attributes :bank_name, :kind, :agency, :number, :digit, :active,
             :created_at, :updated_at

  belongs_to :user
  belongs_to :currency

  has_many :withdraws
end
