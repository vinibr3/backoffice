module AuthorizableConcern
  extend ActiveSupport::Concern

  ACCESS_TOKEN_NAME = 'AuthenticationToken'.freeze
  SECRET = Rails.application.credentials.secret_key_base.freeze
  ALGORITM = 'HS256'.freeze

  attr_reader :current_user

  def find_authenticated(login, password)
    query = []
    attributes = SystemParametrization.current.sign_in_attributes

    query = attributes.map { |a| "users.#{a} ILIKE ?" }.join(' OR ')
    values = attributes.map { |a| login }

    user = User.find_by(query, *values)

    user if user&.authenticate(password)
  end

  def sign_in(user)
    uid = SecureRandom.uuid
    token = build_token(uid)

    update_sign_in_attributes(user, uid)
    add_token_to_response_headers(token)

    @current_user = user
  end

  def authenticate!
    token = decoded_token
    user = User.find_by(uid: token[:uid]) if token.present?

    if user && Time.at(token[:expiring_timestamp]) >= Time.now
      update_token(user)
      @current_user = user
    else
      sign_out(user) if user
      head :unauthorized
    end
  end

  def sign_out(user = nil)
    user = User.find_by(uid: decoded_token[:uid]) if user.blank? && decoded_token[:uid]

    user.update!(uid: '',
                 current_sign_in_at: nil,
                 current_sign_in_ip: nil,
                 last_sign_in_at: user.current_sign_in_at,
                 last_sign_in_ip: user.current_sign_in_ip) if user

    @current_user = nil
  end

  private

  def build_token(uid = SecureRandom.uuid)
    expiring_timestamp = Time.now.to_i + SystemParametrization.current.seconds_to_expire_session

    token = {
      uid: uid,
      expiring_timestamp: expiring_timestamp,
      random: SecureRandom.base64
    }

    JWT.encode(token, SECRET, ALGORITM)
  end

  def decoded_token
    token = request.headers[ACCESS_TOKEN_NAME].to_s

    JWT.decode(token, SECRET, true, { algorithm: ALGORITM }).first.symbolize_keys
  rescue StandardError => e
    {}
  end

  def add_token_to_response_headers(token)
    response.headers[ACCESS_TOKEN_NAME] = token
  end

  def update_sign_in_attributes(user, uid)
    user.update!(sign_in_count: user.sign_in_count + 1,
                 current_sign_in_at: Time.now,
                 current_sign_in_ip: request.remote_ip,
                 last_sign_in_at: Time.now,
                 last_sign_in_ip: request.remote_ip,
                 provider: SystemParametrization.current.registration_attribute,
                 uid: uid)
  end

  def update_token(user)
    token = build_token(user.uid)

    add_token_to_response_headers(token)
  end
end
