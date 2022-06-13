# frozen_literal_string: true

class BonusCommissionSerializer < JSONAPI::Serializable::Resource
  type 'bonus_commissions'

  attributes :generation, :percentage

  belongs_to :financial_reason
  belongs_to :product
end
