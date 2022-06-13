class Order < ApplicationRecord
  belongs_to :user
  belongs_to :currency

  has_many :items
  has_many :products, through: :items
  has_one :payment_transaction, as: :payable

  validates :total, presence: true,
                    numericality: { greater_than_or_equal_to: 0 }
  validates :subtotal, presence: true,
                       numericality: { greater_than_or_equal_to: 0 }
  validates :expire_at, presence: true

  def total=(value)
    if FLOAT_NUMBER_REGEXP.match(value.to_s)
      self[:total] = (value.to_f * 1e8).to_i
    else
      self[:total] = nil
    end
  end

  def total
   self[:total].to_f / 1e8 if self[:total]
  end

  def subtotal=(value)
    if FLOAT_NUMBER_REGEXP.match(value.to_s)
      self[:subtotal] = (value.to_f * 1e8).to_i
    else
      self[:subtotal] = nil
    end
  end

  def subtotal
   self[:subtotal].to_f / 1e8 if self[:subtotal]
  end
end
