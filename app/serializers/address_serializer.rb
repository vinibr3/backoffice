# frozen_string_literal: true

class AddressSerializer < JSONAPI::Serializable::Resource
  type 'addresses'

  attributes :zipcode, :street, :number, :complement, :district, :city, :state, :country,
             :addressable_type, :addressable_id

  belongs_to :user
  belongs_to :admin_user
end
