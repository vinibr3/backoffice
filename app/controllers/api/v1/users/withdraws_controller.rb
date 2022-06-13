# frozen_string_literal: true

class Api::V1::Users::WithdrawsController < UsersController
  before_action :authenticate!

  def index
    render jsonapi: withdraws,
           include: [:user, :admin_user, :currency, receivable_method: [:currency]],
           links: pagination_links(withdraws)
  end

  def create
    withdraw = Withdraws::CreatorService.call(valid_params)

    render jsonapi: withdraw,
           include: [:user, :admin_user, :currency, receivable_method: [:currency]]
  end

  private

  def valid_params
    params.require(:data)
          .permit(attributes: %i[currency_id receivable_method_id
                                receivable_method_type gross_amount confirmation_url])[:attributes]
          .merge(user: current_user)
  end

  def withdraws
    query = current_user.withdraws
                        .includes(:user, :admin_user, :currency, receivable_method: [:currency])
                        .order(id: :desc)

    statuses = query_params[:statuses]
    query.merge!(Withdraw.by_statuses(statuses)) if statuses&.any?

    ids = query_params[:currency_ids]
    query.merge!(Withdraw.by_currency_ids(ids)) if ids&.any?

    types = query_params[:receivable_method_types]
    query.merge!(Withdraw.by_receivable_method_types(types)) if types&.any?

    from = query_params[:created_at_from]
    from = Time.zone.parse(from.present? ? from : 100.years.ago.to_s)
    untill = query_params[:created_at_until]
    untill = Time.parse(untill.present? ? untill : 100.years.from_now.to_s)
    query.merge!(Withdraw.created_at_between(from, untill))

    query.page(page)
         .per(per_page)
  end

  def query_params
    params.permit(:created_at_from, :created_at_until, statuses: [],
                  currency_ids: [], receivable_method_types: [])
  end
end
