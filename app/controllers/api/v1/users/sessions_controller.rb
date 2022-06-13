# frozen_literal_string: true

class Api::V1::Users::SessionsController < UsersController
  before_action :authenticate_bearer_token!

  def create
    user = find_authenticated(valid_params[:login], valid_params[:password])

    head :unprocessable_entity and return if user.blank?

    sign_in(user)

    render_user(user)
  end

  def destroy
    sign_out
  end

  private

  def valid_params
    attributes = params.require(:data)
                       .permit(attributes: [:login, :password])
    attributes[:attributes]
  end
end
