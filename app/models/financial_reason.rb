class FinancialReason < ApplicationRecord
  CODES = {
            direct_indication: 10,
            indirect_indication: 20,
            deposit: 30,
            withdraw: 40,
            order_payment: 50,
          }.freeze

  CHARGEBACK_CODES = { by_inactivity: 1000 }.freeze

  has_many :bonus_commissions
  has_many :financial_transactions

  validates :title, presence: true,
                    length: { maximum: 255 }
  validates :code, presence: true,
                   uniqueness: true

  scope :active, -> { where(active: true) }

  def self.direct_indication
    find_by(code: CODES[:direct_indication]) ||
    create!(code: CODES[:direct_indication], active: true, title: 'Direct Indication Bonus')
  end

  def self.indirect_indication
    find_by(code: CODES[:indirect_indication]) ||
    create!(code: CODES[:indirect_indication], active: true, title: 'Indirect Indication Bonus')
  end

  def self.deposit
    find_by(code: CODES[:deposit]) ||
    create!(code: CODES[:deposit], active: true, title: 'Deposit', chargebackable_by_inactivity: false)
  end

  def self.withdraw
    find_by(code: CODES[:withdraw]) ||
    create!(code: CODES[:withdraw], active: true, title: 'Withdraw', chargebackable_by_inactivity: false)
  end

  def self.order_payment
    find_by(code: CODES[:order_payment]) ||
    create!(code: CODES[:order_payment], active: true, title: 'Order Payment', chargebackable_by_inactivity: false)
  end

  def self.chargeback_by_inactivity
    find_by(code: CHARGEBACK_CODES[:by_inactivity]) ||
    create!(code: CHARGEBACK_CODES[:by_inactivity], active: true, title: 'Chargeback by Inactivity')
  end
end
