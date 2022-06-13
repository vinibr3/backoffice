# frozen_string_literal: true

class ApiCredentialSerializer < JSONAPI::Serializable::Resource
  type 'api_credentials'

  attributes :created_at, :updated_at

  belongs_to :user
end
