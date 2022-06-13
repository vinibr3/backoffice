# frozen_string_literal: true

class WithdrawSerializer < JSONAPI::Serializable::Resource
  type 'withdraws'

  attributes :gross_amount, :net_amount, :fee, :receivable_currency_amount,
             :status, :status_update_at, :created_at, :updated_at,
             :receivable_method_type

  belongs_to :user
  belongs_to :currency
  belongs_to :receivable_method

  has_one :receivable_currency

  has_many :financial_transactions
end
