class Category < ApplicationRecord
  validates :name, presence: true,
                   uniqueness: { case_sensitive: false },
                   length: { maximum: 255 }
  validates :code, presence: true,
                   uniqueness: true
end
