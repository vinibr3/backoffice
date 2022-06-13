# frozen_string_literal: true

class PixSerializer < JSONAPI::Serializable::Resource
  type 'pixes'

  attributes :secret_key, :kind, :active, :created_at, :updated_at

  belongs_to :user
  belongs_to :currency

  has_many :withdraws
end
