require 'rails_helper'

RSpec.describe Api::V1::Users::UserProfilesController, type: :controller do
  describe 'POST create' do
    before { Authentication.with_user_token(@request) }
    before { post :create, params: {data: {attributes: {profile_id: create(:profile)}}} }

    it { is_expected.to(route(:post, '/api/v1/users/user_profiles').to(action: :create)) }
    it { is_expected.to(respond_with(:ok)) }
  end
end
