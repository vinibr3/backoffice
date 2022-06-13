# frozen_string_literal: true

class FinancialTransactions::DirectIndicationCreatorService < ApplicationService
  def call
    return unless @financial_reason.active && SystemParametrization.current.pay_direct_indication_bonus

    ActiveRecord::Base.transaction do
      @order.items.map do |item|
        commission = @commissions.detect { |c| c.product_id == item.product_id && c.generation == 1 }

        creates_direct_indication_bonus(item, commission) if commission.present?
      end
    end
  end

  private

  def initialize(args)
    @order = args[:order]
    @sponsor = @order.user.sponsor
    @financial_reason = FinancialReason.direct_indication
    @commissions = @financial_reason.bonus_commissions
  end

  def creates_direct_indication_bonus(item, commission)
    amount = (item.total_price * commission.percentage / 100.0).round(2)

    @sponsor.financial_transactions
            .create!(spreader_user: @order.user,
                     order: @order,
                     financial_reason: @financial_reason,
                     currency: Currency.dollar,
                     bonus_commission: commission,
                     note: '',
                     user_amount: amount,
                     user_cashflow: :in,
                     admin_amount: -amount,
                     admin_cashflow: :out,
                     system_amount: 0,
                     system_cashflow: :not_applicable,
                     product: item.product) if amount.positive?
  end
end
