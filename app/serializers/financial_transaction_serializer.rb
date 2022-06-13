# frozen_literal_string: true

class FinancialTransactionSerializer < JSONAPI::Serializable::Resource
  type 'financial_transactions'

  attributes :note, :user_amount, :user_cashflow, :admin_amount, :admin_cashflow,
             :system_amount, :system_cashflow, :created_at, :updated_at

  belongs_to :user
  belongs_to :spreader_user
  belongs_to :order
  belongs_to :financial_reason
  belongs_to :currency
  belongs_to :bonus_commission
  belongs_to :product
  belongs_to :chargebacker_by_inactivity
end
