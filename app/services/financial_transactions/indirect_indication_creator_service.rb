# frozen_string_literal: true

class FinancialTransactions::IndirectIndicationCreatorService < ApplicationService
  def call
    return unless @financial_reason.active && SystemParametrization.current.pay_indirect_indication_bonus
    return if @commissions.empty?

    ActiveRecord::Base.transaction do
      @order.items.map do |item|
        creates_indirect_indication_bonus_for_sponsors(item)
      end
    end
  end

  private

  INDEX_OF_FIRST_GENERATION_THAT_RECEIVES_BONUS = 2
  FIRST_GENERATION_INDEX = 1

  def initialize(args)
    @order = args[:order]
    @sponsor = @order.user.sponsor
    @financial_reason = FinancialReason.indirect_indication
    @commissions = @financial_reason.bonus_commissions
  end

  def creates_indirect_indication_bonus_for_sponsors(item)
    sponsors.map.with_index do |sponsor, index|
      generation = index + INDEX_OF_FIRST_GENERATION_THAT_RECEIVES_BONUS
      commission = @commissions.detect { |c| c.product_id == item.product_id && c.generation == generation }
      next if commission.blank?

      creates_indirect_indication_bonus(sponsor, item, commission) if commission
    end
  end

  def sponsors
    generations_count = @commissions.map(&:generation).max - FIRST_GENERATION_INDEX

    @sponsors ||= @sponsor.unilevel_node
                          .sponsors_by_count(generations_count)
  end

  def creates_indirect_indication_bonus(sponsor, item, commission)
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
