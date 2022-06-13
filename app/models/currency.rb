class Currency < ApplicationRecord
  INITIALS = {
               dollar: 'USD',
               bitcoin: 'BTC',
               ethereum: 'ETH'
             }.freeze

  has_many :payment_methods

  validates :name, presence: true,
                   uniqueness: true,
                   length: { maximum: 255 }
  validates :initials, presence: true,
                       uniqueness: true,
                       length: { maximum: 255 }
  validates :scale, presence: true,
                    numericality: true

  scope :active, -> { where(active: true) }

  def self.dollar
    find_by(initials: INITIALS[:dollar]) || create!(name: 'Dollar',
                                                    initials: INITIALS[:dollar],
                                                    scale: 2,
                                                    crypto: false,
                                                    active: true,
                                                    symbol: 'US $',
                                                    order_payment_enabled: false,
                                                    deposit_payment_enabled: false,
                                                    withdraw_enabled: true,
                                                    receivable_method_enabled: false)
  end
end
