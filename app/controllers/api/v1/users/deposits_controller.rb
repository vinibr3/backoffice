# frozen_literal_string: true

class Api::V1::Users::DepositsController < UsersController
  before_action :authenticate!

  def index
    render jsonapi: deposits,
           include: %i[user currency payment_transaction payment_method payment_currency],
           links: pagination_links(deposits)
  end

  def create
    deposit = Deposits::CreatorService.call(user: current_user,
                                            amount: valid_params[:amount],
                                            payment_method_id: valid_params[:payment_method_id],
                                            currency_id: valid_params[:currency_id])

    render jsonapi: deposit,
           include: [:user, :currency, :payment_transaction, :payment_method, :payment_currency]
  end

  private

  def deposits
    query = current_user.deposits
                        .includes(:user, :currency, :payment_transaction, :payment_method, :payment_currency)
                        .order(created_at: :desc)

    id = query_params[:currency_id].to_i
    query.merge!(Deposit.by_currency_id(id)) if id.positive?

    id = query_params[:payment_method_id].to_i
    query.merge!(Deposit.by_payment_method_id(id)) if id.positive?

    status = query_params[:payment_transaction_status]
    query.merge!(Deposit.by_status(status)) if status.present?

    from = query_params[:paid_at_from]
    untill = query_params[:paid_at_until]

    if from.present? || untill.present?
      from = Time.zone.parse(from.present? ? from : 100.years.ago.to_s)
      untill = Time.parse(untill.present? ? untill : 100.years.from_now.to_s)
      query.merge!(Deposit.by_paid_at_between(from, untill))
    end

    from = query_params[:created_at_from]
    from = Time.zone.parse(from.present? ? from : 100.years.ago.to_s)
    untill = query_params[:created_at_until]
    untill = Time.parse(untill.present? ? untill : 100.years.from_now.to_s)
    query.merge!(Deposit.by_created_at_between(from, untill))

    query.page(page)
         .per(per_page)
  end

  def query_params
    params.permit(:currency_id, :payment_method_id, :payment_transaction_status,
                  :paid_at_from, :paid_at_until, :created_at_from, :created_at_until)
  end

  def valid_params
    params.require(:data)
          .permit(attributes: [:amount, :currency_id, :payment_method_id])[:attributes]
  end
end
