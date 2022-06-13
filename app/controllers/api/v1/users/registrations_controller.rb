# frozen_literal_string: true

class Api::V1::Users::RegistrationsController < UsersController
  before_action :authenticate_bearer_token!
  before_action :validate_registration_confirmation_url, only: :create,
                                                         if: proc { SystemParametrization.current.user_confirmable_on_register }
  before_action :validate_presence_of_sponsor_token, only: :create,
                                                     if: proc { SystemParametrization.current.mandatory_register_with_sponsor_token }

  def create
    user = User.create!(valid_params.except(:sponsor_token, :registration_confirmation_url))
    RegistrationMailer.with(user: user).new.deliver_later
    if SystemParametrization.current.user_confirmable_on_register
      user.update!(confirmation_token: SecureRandom.hex,
                   confirmation_token_sent_at: Time.now)

      url = valid_params[:registration_confirmation_url]
      RegistrationMailer.with(user: user, registration_confirmation_url: url)
                        .confirm.deliver_later
    end
    if SystemParametrization.current.mandatory_register_with_sponsor_token
      unilevel_node =
        sponsor.unilevel_node || UnilevelNode.network_head!.children.create!(user: User.network_head!, sponsored: sponsor)
      unilevel_node.children.create!(user: sponsor, sponsored: user)
    end
    profile = Profile.first
    Users::UserProfiles::CreatorService.call(user: user, profile: profile) if profile
    sign_in(user)
    render_user(user)
  end

  private

  def valid_params
    registration_attribute = SystemParametrization.current.registration_attribute.to_sym
    permited_attributes =
      [registration_attribute, :password, :password_confirmation, :sponsor_token,
       :registration_confirmation_url]

    params.require(:data)
          .permit(attributes: permited_attributes)[:attributes]
          .merge(provider: registration_attribute)
  end

  def validate_registration_confirmation_url
    errors = []

    if !valid_params[:registration_confirmation_url].to_s.match?(URL_REGEXP)
      errors << json_api_error(:invalid, :registration_confirmation_url)
    end

    return if errors.empty?

    render jsonapi_errors: errors,
           status: :unprocessable_entity
  end

  def validate_presence_of_sponsor_token
    render(jsonapi_errors: [json_api_error(:invalid, :sponsor_token)],
           status: :unprocessable_entity) if sponsor.blank?
  end

  def sponsor
    return if valid_params[:sponsor_token].blank?

    @sponsor ||= User.find_by(sponsor_token: valid_params[:sponsor_token])
  end
end
