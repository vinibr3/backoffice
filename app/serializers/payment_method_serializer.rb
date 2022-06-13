# frozen_string_literal: true

class PaymentMethodSerializer < JSONAPI::Serializable::Resource
  type 'payment_methods'

  attributes :name, :active, :code

  belongs_to :currency
end
