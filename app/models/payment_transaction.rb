class PaymentTransaction < ApplicationRecord
  enum status: %w[unpaid paid]

  belongs_to :payable, polymorphic: true,
                       optional: true
  belongs_to :payment_method

  validates :transaction_code, presence: true,
                               uniqueness: true,
                               length: { maximum: 255 }
  validates :amount, presence: true,
                     numericality: { greater_than: 0 }
  validates :creation_response, presence: true,
                                if: :paid?
  validates :notification_response, presence: true,
                                    if: :paid?

  scope :by_payment_method_id, ->(id) { where(payment_method_id: id) }
  scope :by_paid_at, ->(from, untill) { where(paid_at: (from..untill)) }

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
