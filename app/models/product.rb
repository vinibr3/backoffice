class Product < ApplicationRecord
  belongs_to :category, class_name: 'Category',
                        foreign_key: :category_id
  belongs_to :profile, class_name: 'Profile',
                       foreign_key: :profile_id,
                       optional: true

  has_many :bonus_commissions

  validates :price, presence: true,
                    numericality: { greater_than_or_equal_to: 0 }
  validates :name, presence: true,
                   length: { maximum: 255 }
  validates :code, presence: true,
                   uniqueness: true

  scope :active, -> { where(active: true) }

  def price=(amount)
   self[:price] = (amount.to_f * 1e8).to_i if FLOAT_NUMBER_REGEXP.match amount.to_s
  end

  def price
   self[:price].to_f / 1e8 if self[:price]
  end
end
