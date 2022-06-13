class PaymentMethod < ApplicationRecord
  VALID_CODES = {
                 btc_plisio: '10',
                 eth_plisio: '20'
                }.freeze

  belongs_to :currency

  validates :name, presence: true,
                   uniqueness: true,
                   length: { maximum: 255 }
  validates :code, presence: true,
                   uniqueness: true,
                   length: { maximum: 255 }

  scope :active, -> { where(active: true) }
end
