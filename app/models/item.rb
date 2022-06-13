class Item < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, presence: true,
                       numericality: { greater_than: 0 }
  validates :unit_price, presence: true,
                         numericality: { greater_than_or_equal_to: 0 }
  validates :total_price, presence: true,
                          numericality: { greater_than_or_equal_to: 0 }

  def unit_price=(value)
    if FLOAT_NUMBER_REGEXP.match(value.to_s)
      self[:unit_price] = (value.to_f * 1e8).to_i
    else
      self[:unit_price] = nil
    end
  end

  def unit_price
    self[:unit_price].to_f / 1e8 if self[:unit_price]
  end

  def total_price=(value)
    if FLOAT_NUMBER_REGEXP.match(value.to_s)
      self[:total_price] = (value.to_f * 1e8).to_i
    else
      self[:total_price] = nil
    end
  end

  def total_price
    self[:total_price].to_f / 1e8 if self[:total_price]
  end
end
