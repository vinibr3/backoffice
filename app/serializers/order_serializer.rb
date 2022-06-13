# frosen_string_literal: true

class OrderSerializer < JSONAPI::Serializable::Resource
  type 'orders'

  attributes :subtotal, :total, :expire_at, :created_at, :updated_at

  belongs_to :user
  belongs_to :currency

  has_many :items
  has_one :payment_transaction, as: :payable

  link :self do
    @url_helpers.api_v1_users_order_url(@object)
  end
end
