class Profile < ApplicationRecord
  validates :name, presence: true,
                   length: { maximum: 255 }
  validates :trade_fee_percentage, presence: true,
                                   numericality: true
  validates :duration_days_per_purchase, presence: true,
                                         numericality: { greater_than: 0 }
  validates :duration_days_per_monthly_result, presence: true,
                                               numericality: { greater_than: 0 }
  validates :monthly_qualification_amount, presence: true,
                                           numericality: { greater_than_or_equal_to: 0 }
end
