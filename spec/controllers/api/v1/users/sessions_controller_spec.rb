require 'rails_helper'

RSpec.describe Api::V1::Users::SessionsController, type: :controller do

  context 'POST create' do
    let(:login_attribute) { SystemParametrization.current.sign_in_attributes.sample.to_sym }
    let(:password) { '1111111111' }
    let(:user) { create(:user, password: password, password_confirmation: password) }

    before { Authentication.with_bearer_token(@request) }

    describe 'when valid params' do
      let(:attributes) { { login: user.read_attribute(login_attribute),
                           password: password } }

      before { get :create, params: { data: { attributes: attributes } } }

      it { is_expected.to(route(:post, '/api/v1/users/sessions').to(action: 'create')) }
      it { is_expected.to(respond_with(:ok)) }

      it 'sign in user' do
        authorization_token = response.headers[AuthorizableConcern::ACCESS_TOKEN_NAME]

        expect(authorization_token).to be_present
      end
    end

    describe 'when invalid params' do
      context 'with wrong password' do
        let(:attributes) { { login: user.read_attribute(login_attribute),
                             password: Faker::Internet.password } }

        before { get :create, params: { data: { attributes: attributes } } }

        it { is_expected.to(respond_with(:unprocessable_entity)) }
      end
    end
  end

  context 'DELETE #destroy' do
    let(:user) { create(:user) }

    before { Authentication.with_bearer_token(@request) }
    before { delete :destroy, params: { id: user.id } }

    describe 'when valid params' do
      it { is_expected.to(route(:delete, 'api/v1/users/sessions/1').to(action: 'destroy', id: 1)) }

      context 'authorization_token valid' do
        before { Authentication.with_user_token(@request) }

        it { is_expected.to(respond_with(:no_content)) }

        it 'remove authorization_token from header' do
          authorization_token = response.headers[AuthorizableConcern::ACCESS_TOKEN_NAME]

          expect(authorization_token).to be_blank
        end
      end

      context 'with authorization_token expired' do
        before { Authentication.with_user_expired_token(@request) }

        it { is_expected.to(respond_with(:no_content)) }

        it 'remove authorization_token from header' do
          authorization_token = response.headers[AuthorizableConcern::ACCESS_TOKEN_NAME]

          expect(authorization_token).to be_blank
        end
      end
    end
  end

  describe 'when invalid params' do
    before { delete :destroy, params: { id: 1 } }

    context 'without authorization_token' do
      it { is_expected.to(respond_with(:unauthorized)) }
    end
  end
end
