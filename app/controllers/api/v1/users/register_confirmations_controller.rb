class Api::V1::Users::RegisterConfirmationsController < UsersController
  before_action :authenticate_bearer_token!

  def create
    confirmation_token = params.dig(:confirmation_token)
    user = User.find_by(confirmation_token: confirmation_token) if confirmation_token.present?

    expiring_time = SystemParametrization.current.seconds_to_expire_confirmation_token.seconds.ago
    render_record_not_found_error and return if user.blank? || user.confirmation_token_sent_at < expiring_time

    user.update!(confirmation_token: '',
                 confirmation_token_sent_at: nil,
                 confirmed_at: Time.now)
  end
end
