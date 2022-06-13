# frozen_literal_string: true

class Api::V1::Users::FinancialTransactionsController < UsersController
  before_action :authenticate!

  def index
    transactions = financial_transactions.page(page)
                                         .per(per_page)

    render jsonapi: transactions,
           include: %i[financial_reason bonus_commission spreader_user order
                       currency product chargebacker_by_inactivity user],
           links: pagination_links(transactions)
  end

  private

  def financial_transactions
    query = current_user.financial_transactions
                        .includes(%i[financial_reason bonus_commission spreader_user order
                                    currency product chargebacker_by_inactivity user])
                        .order(id: :desc)
                        .where(user_cashflow: [:in, :out])

    id = valid_params[:financial_reason_id].to_i
    query.merge!(FinancialTransaction.by_financial_reason_id(id)) if id.positive?

    id = valid_params[:currency_id].to_i
    query.merge!(FinancialTransaction.by_currency_id(id)) if id.positive?

    id = valid_params[:bonus_commission_id].to_i
    query.merge!(FinancialTransaction.by_bonus_commission_id(id)) if id.positive?

    attribute = valid_params[:spreader_user_uniq_attribute]
    query.merge!(FinancialTransaction.by_spreader_user_unique_attribute(attribute)) if attribute.present?

    id = valid_params[:order_id].to_i
    query.merge!(FinancialTransaction.by_order_id(id)) if id.positive?

    id = valid_params[:product_id].to_i
    query.merge!(FinancialTransaction.by_product_id(id)) if id.positive?

    from = valid_params[:created_at_from]
    from = Time.zone.parse(from.present? ? from : 100.years.ago.to_s)
    untill = valid_params[:created_at_until]
    untill = Time.parse(untill.present? ? untill : Time.now.end_of_day.to_s)

    query.merge!(FinancialTransaction.by_created_at_between(from, untill))
  end

  def valid_params
    params.permit(:financial_reason_id, :currency_id, :created_at_from,
                  :created_at_until, :bonus_commission_id, :order_id,
                  :product_id, :spreader_user_uniq_attribute)
  end
end
