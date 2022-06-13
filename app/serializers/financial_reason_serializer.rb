# frozen_literal_string: true

class FinancialReasonSerializer < JSONAPI::Serializable::Resource
  type 'financial_reasons'

  attributes :title, :code, :active, :chargebackable_by_inactivity, :created_at,
             :updated_at
end
