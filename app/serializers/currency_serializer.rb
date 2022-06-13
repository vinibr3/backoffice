# frozen_string_literal: true

class CurrencySerializer < JSONAPI::Serializable::Resource
  type 'currencies'

  attributes :name, :initials, :scale, :symbol, :crypto, :active, :order_payment_enabled,
             :deposit_payment_enabled, :withdraw_enabled, :receivable_method_enabled,
             :created_at, :updated_at
end
