# frozen_string_literal: true

class UnilevelNodeSerializer < JSONAPI::Serializable::Resource
  type 'unilevel_nodes'

  attributes :created_at, :updated_at, :ancestry_depth, :ancestry

  belongs_to :user
  belongs_to :sponsored
end
