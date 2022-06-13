# frozen_literal_string: true

class Api::V1::Users::UserProfilesController < UsersController
  before_action :authenticate!

  def create
    profile = Profile.find(valid_params[:profile_id])

    user_profile =
      Users::UserProfiles::CreatorService.call(user: current_user, profile: profile)

    render jsonapi: user_profile,
           include: [:user, :profile]
  end

  def valid_params
    params.require(:data)
          .permit(attributes: [:profile_id])[:attributes]
  end
end
