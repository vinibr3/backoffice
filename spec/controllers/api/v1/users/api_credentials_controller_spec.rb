require 'rails_helper'

RSpec.describe Api::V1::Users::ApiCredentialsController, type: :controller do
  context 'POST create' do
    it { is_expected.to(route(:post, '/api/v1/users/api_credentials').to(action: 'create')) }

    context 'without user authentication' do
      before { post :create }

      it { is_expected.to(respond_with(:unauthorized)) }
    end

    context 'with user authentication' do
      let(:user) { create(:user) }
      let(:api_credential) { build(:api_credential) }
      let(:attributes) { { attributes: { key: api_credential.key, secret: api_credential.secret } } }

      before { Authentication.with_user_token(@request, user) }
      before { post :create, params: { data: attributes } }

      it { is_expected.to(respond_with(:ok)) }

      it 'saves key' do
        expect(user.api_credentials.first.key).to eq(api_credential.key)
      end

      it 'saves secret' do
        expect(user.api_credentials.first.secret).to eq(api_credential.secret)
      end

      it 'renders api_credential as jsonapi' do
        expect(response).to be_jsonapi_data_of_type('api_credentials')
      end
    end
  end

  context 'PATCH update' do
    it { is_expected.to(route(:patch, '/api/v1/users/api_credentials/1').to(action: 'update', id: 1)) }

    context 'without user authentication' do

      before { patch :update, params: { id: 1 } }

      it { is_expected.to(respond_with(:unauthorized)) }
    end

    context 'with user authentication' do
      let(:api_credential) { create(:api_credential) }
      let(:credential) { build(:api_credential) }
      let(:attributes) { { attributes: { key: credential.key, secret: credential.secret } } }

      before { Authentication.with_user_token(@request, api_credential.user) }
      before { patch :update, params: { data: attributes, id: api_credential.id } }

      it { is_expected.to(respond_with(:ok)) }

      it 'saves key' do
        expect(api_credential.reload.key).to eq(credential.key)
      end

      it 'saves secret' do
        expect(api_credential.reload.secret).to eq(credential.secret)
      end

      it 'renders api_credential as jsonapi' do
        expect(response).to be_jsonapi_data_of_type('api_credentials')
      end
    end
  end
end
