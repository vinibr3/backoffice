require 'rails_helper'

RSpec.describe Api::V1::Users::RegisterConfirmationsController, type: :controller do
  before { Authentication.with_bearer_token(@request) }

  context 'with valid confirmation token' do
    let(:user) { create(:user, :with_valid_confirmation_token) }
    let(:attributes) { { confirmation_token: user.confirmation_token } }

    before { post :create, params: attributes }

    it { is_expected.to(respond_with(:no_content)) }

    it 'confirm user' do
      expect(user.reload.confirmed_at).to be_present
    end

    it 'clean confirmation_token' do
      expect(user.reload.confirmation_token).to be_empty
    end

    it 'clean confirmation token sent at' do
      expect(user.reload.confirmation_token_sent_at).to be_nil
    end

    it { is_expected.to(route(:post, '/api/v1/users/register_confirmations').to(action: :create)) }
    it { is_expected.to(use_before_action(:authenticate_bearer_token!)) }
  end

  context 'with invalid confirmation token' do
    let(:attributes) { { confirmation_token: SecureRandom.hex } }

    before { post :create, params: attributes }

    it { is_expected.to(respond_with(:not_found)) }
  end
end
