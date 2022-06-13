# frosen_string_literal: true

class ItemSerializer < JSONAPI::Serializable::Resource
  type 'items'

  attributes :quantity, :unit_price, :total_price, :created_at, :updated_at

  belongs_to :product
end
