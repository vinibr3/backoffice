class AdminUser < ApplicationRecord
  enum gender: { male: 0, female: 1 }

  has_one :compliance_user, foreign_key: :compliance_admin_user_id,
                            class_name: 'User'

  validates :email, presence: true,
                    length: { maximum: 255 },
                    format: { with: URI::MailTo::EMAIL_REGEXP },
                    uniqueness: true
  validates :name, length: { maximum: 255 }
  validates :phone, length: { maximum: 255 }
  validates :document, length: { maximum: 255 }
end
