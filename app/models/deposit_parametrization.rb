class DepositParametrization < ApplicationRecord
  belongs_to :currency

  validates :minimum_amount, numericality: { greater_than: 0 }
  validates :maximum_amount, numericality: { greater_than: 0 }
  validate :maximum_amount_greather_than_minimum_amount, if: proc { |w| w.maximum_amount && w.minimum_amount }

  def minimum_amount=(value)
    if FLOAT_NUMBER_REGEXP.match(value.to_s)
      self[:minimum_amount] = (value.to_f * 1e8).to_i
    else
      self[:minimum_amount] = nil
    end
  end

  def minimum_amount
    self[:minimum_amount].to_f / 1e8 if self[:minimum_amount]
  end

  def maximum_amount=(value)
    if FLOAT_NUMBER_REGEXP.match(value.to_s)
      self[:maximum_amount] = (value.to_f * 1e8).to_i
    else
      self[:maximum_amount] = nil
    end
  end

  def maximum_amount
    self[:maximum_amount].to_f / 1e8 if self[:maximum_amount]
  end

  def maximum_amount_greather_than_minimum_amount
    errors.add(:maximum_amount, :invalid) if maximum_amount <= minimum_amount
  end
end
