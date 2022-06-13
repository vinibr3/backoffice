# frozen_string_literal: true

class PaymentTransactionSerializer < JSONAPI::Serializable::Resource
  type 'payment_transactions'

  attributes :status, :transaction_code, :amount, :paid_at, :digital_address,
             :qr_code_base64, :created_at, :updated_at

  belongs_to :payment_method
end
