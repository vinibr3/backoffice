# frozen_literal_string: true

class Api::V1::Users::SystemParametrizationsController < UsersController
  before_action :authenticate_bearer_token!

  def index
    render jsonapi: [SystemParametrization.current]
  end
end
