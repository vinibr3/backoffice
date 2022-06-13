class Pix < ApplicationRecord
  enum kind: { detached: 0, document: 1, cellphone: 2, email: 3 }

  belongs_to :currency
  belongs_to :user

  has_many :withdraws, as: :receivable_method

  validates :secret_key, presence: true,
                         length: { maximum: 255 }
  validates :kind, presence: true
end
