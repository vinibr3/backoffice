# frozen_string_literal: true

class Api::V1::Users::ApiCredentialsController < UsersController
  before_action :authenticate!

  def create
    api_credential = current_user.api_credentials.create!(valid_params)

    render jsonapi: api_credential,
           include: :user
  end

  def update
    api_credential = current_user.api_credentials.find(params[:id])
    api_credential.update!(valid_params)

    render jsonapi: api_credential,
           include: :user
  end

  private

  def valid_params
    params.require(:data)
          .permit(attributes: [:key, :secret])
          .merge(user: current_user)
  end
end
