# frozen_string_literal: true

class CategorySerializer < JSONAPI::Serializable::Resource
  type 'categories'

  attributes :name, :active, :code, :created_at, :updated_at
end
