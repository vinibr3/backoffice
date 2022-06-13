require 'rails_helper'

RSpec.describe Api::V1::Users::WithdrawConfirmationsController, type: :controller do
  describe 'PATCH update' do
    it { is_expected.to(route(:post, '/api/v1/users/withdraw_confirmations').to(action: :create)) }
    it { is_expected.to(use_before_action(:authenticate_bearer_token!)) }

    context 'when do not authenticate_bearer_token' do
      before { post :create }

      it { is_expected.to(respond_with(:unauthorized)) }
    end

    context 'when authenticate_bearer_token' do
      let(:withdraw) { create(:withdraw, status: :confirmation) }
      let(:data) { { data: { attributes: { confirmation_token: withdraw.confirmation_token } } } }

      before { Authentication.with_bearer_token(@request) }
      before { post :create, params: data }

      it { is_expected.to(respond_with(:ok)) }

      it 'return withdraw with status created' do
        status = JSON.parse(response.body)['data']['attributes']['status']

        expect(status).to eq('created')
      end
    end
  end
end
