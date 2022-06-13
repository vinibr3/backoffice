class Deposit < ApplicationRecord
  belongs_to :user
  belongs_to :currency

  has_one :financial_transaction
  has_one :payment_transaction, as: :payable
  has_one :payment_method, through: :payment_transaction
  has_one :payment_currency, through: :payment_method,
                             class_name: 'Currency',
                             source: 'currency'

  validates :amount, numericality: { greater_than: 0 }

  scope :by_currency_id, -> (id) { where(currency_id: id) }
  scope :by_payment_method_id,
    -> (id) { where(payment_transaction: PaymentTransaction.by_payment_method_id(id)) }
  scope :by_status,
    ->(status) { where(payment_transaction: PaymentTransaction.where(status: status)) }
  scope :by_created_at_between, -> (from, untill) { where(created_at: (from..untill)) }
  scope :by_paid_at_between,
    -> (from, untill) { where(payment_transaction: PaymentTransaction.by_paid_at(from, untill)) }

  def amount=(value)
    if FLOAT_NUMBER_REGEXP.match(value.to_s)
      self[:amount] = (value.to_f * 1e8).to_i
    else
      self[:amount] = nil
    end
  end

  def amount
    self[:amount].to_f / 1e8 if self[:amount]
  end
end
