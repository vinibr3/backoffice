class Address < ApplicationRecord
  has_one_attached :proove
  belongs_to :addressable, polymorphic: true

  validates :zipcode, length: { maximum: 255 }
  validates :street, length: { maximum: 255 }
  validates :number, length: { maximum: 255 }
  validates :complement, length: { maximum: 255 }
  validates :district, length: { maximum: 255 }
  validates :city, length: { maximum: 255 }
  validates :state, length: { maximum: 255 }
  validates :country, length: { maximum: 255 }
end
