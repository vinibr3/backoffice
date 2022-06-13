# frozen_literal_string: true

class Api::V1::Users::PasswordsController < UsersController
  before_action :authenticate_bearer_token!, only: %i[new create]
  before_action :authenticate!, only: :update
  before_action :validate_email_and_reset_password_url, only: :new

  def new
    user = User.find_by(email: new_params[:email]) if new_params[:email].present?

    render_record_not_found_error and return if user.blank?

    user.update!(reset_password_token: SecureRandom.hex,
                 reset_password_token_sent_at: Time.now)
    PasswordMailer.with(user: user, reset_password_url: new_params[:reset_password_url])
                  .new.deliver_later
  end

  def create
    token = params.dig(:data, :attributes, :reset_password_token)
    user = User.find_by(reset_password_token: token) if token.present?

    expiring_time = SystemParametrization.current.seconds_to_expire_reset_password_token.seconds.ago
    render_record_not_found_error and return if user.blank? || user.reset_password_token_sent_at < expiring_time

    user.update!(create_params)
  end

  def update
    raise ActiveRecord::RecordNotFound if !current_user.authenticate(update_params[:current_password])

    current_user.update!(update_params.except(:current_password))

    render_user(current_user)
  end

  private

  def new_params
    params.permit(:email, :reset_password_url)
  end

  def create_params
    attributes =
      params.require(:data)
            .permit(attributes: [:password, :password_confirmation, :reset_password_token])
    attributes[:attributes].merge(reset_password_token: '', reset_password_token_sent_at: nil)
  end

  def update_params
    attributes =
      params.require(:data)
            .permit(attributes: [:password, :password_confirmation, :current_password])[:attributes]
  end

  def validate_email_and_reset_password_url
    errors = []

    errors << json_api_error(:invalid, :email) if !new_params[:email].to_s.match?(EMAIL_REGEXP)
    errors << json_api_error(:invalid, :reset_password_url) if !new_params[:reset_password_url].to_s.match?(URL_REGEXP)

    return if errors.empty?

    render jsonapi_errors: errors,
           status: :unprocessable_entity
  end
end
