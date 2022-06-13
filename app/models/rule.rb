class Rule < ApplicationRecord
  has_many :rule_ruleables

  validates :code, presence: true,
                   uniqueness: true
  validates :description, presence: true
  validates :name, presence: true,
                   length: { maximum: 255 }
end
