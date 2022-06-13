module Authentication
  def self.with_bearer_token(request)
    token = "Bearer #{Rails.application.credentials.test[:authorization_key]}"

    request.headers['Authorization'] = token
  end

  def self.with_user_token(request, user = nil)
    user = user || FactoryBot.create(:user)

    token = build_token(user.uid)
    request.headers[AuthorizableConcern::ACCESS_TOKEN_NAME] = token
  end

  def self.with_payment_gateway_key(request)
    token = "Bearer #{Rails.application.credentials[Rails.env.to_sym][:gateway_authorization_key]}"

    request.headers['Authorization'] = token
  end

  def self.with_user_expired_token(request)
    user = FactoryBot.create(:user)

    token = build_expired_token(user.uid)
    request.headers[AuthorizableConcern::ACCESS_TOKEN_NAME] = token
  end

  private

  def self.build_token(uid = SecureRandom.uuid)
    expiring_timestamp = Time.now.to_i + SystemParametrization.current.seconds_to_expire_session

    token = {
      uid: uid,
      expiring_timestamp: expiring_timestamp,
      random: SecureRandom.base64
    }

    JWT.encode(token, AuthorizableConcern::SECRET, AuthorizableConcern::ALGORITM)
  end

  def self.build_expired_token(uid = SecureRandom.uuid)
    expiring_timestamp = 1.day.ago.to_i

    token = {
      uid: uid,
      expiring_timestamp: expiring_timestamp,
      random: SecureRandom.base64
    }

    JWT.encode(token, AuthorizableConcern::SECRET, AuthorizableConcern::ALGORITM)
  end
end
