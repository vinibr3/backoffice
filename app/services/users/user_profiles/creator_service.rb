# frozen_literal_string: true

class Users::UserProfiles::CreatorService < ApplicationService
  def call
    return if @profile.blank?

    current_profile = @user.user_profiles.order(:id).last.try(:profile)

    if @profile.id >= current_profile.try(:id).to_i
      expire_at = @profile.duration_days_per_purchase.days.from_now

      @user.update!(profile: @profile, active_until_at: expire_at)
      @user.user_profiles
           .create!(profile: @profile, expire_at: expire_at)
    else
      @user.user_profiles.last
    end
  end

  private

  def initialize(args)
    @user = args[:user]
    @profile = args[:profile]
  end
end
