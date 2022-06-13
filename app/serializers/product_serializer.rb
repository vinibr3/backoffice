# frozen_string_literal: true

class ProductSerializer < JSONAPI::Serializable::Resource
  type 'products'

  attributes :price, :name, :description, :active, :code, :created_at,
             :updated_at

  belongs_to :category
  belongs_to :profile
end
