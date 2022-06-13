class Wallet < ApplicationRecord
  belongs_to :user
  belongs_to :currency

  has_many :withdraws, as: :receivable_method

  validates :secret_hash, presence: true,
                          length: { maximum: 255 }
end
