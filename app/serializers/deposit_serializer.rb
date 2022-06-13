# frozen_string_literal: true

class DepositSerializer < JSONAPI::Serializable::Resource
  type 'deposits'

  attributes :amount, :created_at, :updated_at

  belongs_to :user
  belongs_to :currency

  has_one :payment_transaction, as: :payable
  has_one :payment_method, through: :payment_transaction
  has_one :payment_currency, through: :payment_method
end
