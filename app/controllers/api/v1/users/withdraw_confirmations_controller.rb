# frozen_string_literal: true

class Api::V1::Users::WithdrawConfirmationsController < UsersController
  before_action :authenticate_bearer_token!

  def create
    withdraw = Withdraw.confirmation
                       .find_by(confirmation_token: valid_params[:confirmation_token])
    withdraw.created!

    render jsonapi: withdraw,
           include: [:user, :admin_user, :currency, receivable_method: [:currency]]
  end

  private

  def valid_params
    params.require(:data)
          .permit(attributes: [:confirmation_token])[:attributes]
  end
end
