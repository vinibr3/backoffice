class WithdrawParametrization < ApplicationRecord
  belongs_to :currency

  validates :minimum_amount, numericality: { greater_than: 0 }
  validates :maximum_amount, numericality: { greater_than: 0 },
                             allow_blank: true
  validate :maximum_amount_greather_than_minimum_amount, if: proc { |w| w.maximum_amount && w.minimum_amount }

  def minimum_amount=(value)
    if FLOAT_NUMBER_REGEXP.match(value.to_s)
      self[:minimum_amount] = (value.to_f * 1e8).to_i
    else
      self[:minimum_amount] = value
    end
  end

  def minimum_amount
    self[:minimum_amount].to_f / 1e8 if self[:minimum_amount]
  end

  def maximum_amount=(value)
    if FLOAT_NUMBER_REGEXP.match(value.to_s)
      self[:maximum_amount] = (value.to_f * 1e8).to_i
    else
      self[:maximum_amount] = value
    end
  end

  def maximum_amount
    self[:maximum_amount].to_f / 1e8 if self[:maximum_amount]
  end

  def maximum_amount_greather_than_minimum_amount
    errors.add(:maximum_amount, :invalid) if maximum_amount <= minimum_amount
  end

  def self.current(currency)
    where(currency: currency).last ||
    create!(minimum_amount: 0.0001, maximum_amount: nil, currency: currency)
  end

  def self.valid?(currency, amount)
    return false if amount <= 0

    parametrization = current(currency)
    return false if parametrization.maximum_amount && parametrization.maximum_amount < amount

    amount >= parametrization.minimum_amount
  end
end
