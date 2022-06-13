class BonusCommission < ApplicationRecord
  belongs_to :financial_reason
  belongs_to :product, optional: true
  has_many :financial_transactions

  validates :generation, presence: true,
                         numericality: true
  validates :percentage, presence: true,
                         numericality: true
end
