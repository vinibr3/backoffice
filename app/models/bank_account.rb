class BankAccount < ApplicationRecord
  enum kind: { checking: 0, savings: 1 }

  belongs_to :currency
  belongs_to :user

  has_many :withdraws, as: :receivable_method

  validates :bank_name, presence: true,
                        length: { maximum: 255 }
  validates :kind, presence: true
  validates :agency, presence: true,
                     length: { maximum: 255 }
  validates :number, presence: true,
                     length: { maximum: 255 }
  validates :digit, presence: true,
                    length: { maximum: 255 }
end
