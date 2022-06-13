class UserProfile < ApplicationRecord
  belongs_to :user
  belongs_to :profile

  validates :expire_at, presence: true
end
