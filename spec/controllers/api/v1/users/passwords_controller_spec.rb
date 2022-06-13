require 'rails_helper'

RSpec.describe Api::V1::Users::PasswordsController, type: :controller do
  before { Authentication.with_bearer_token(@request) }

  context 'GET new' do
    describe 'with valid params' do
      let(:user) { create(:user) }
      let(:attributes) { { email: user.email, reset_password_url: Faker::Internet.url } }

      before { get :new, params: attributes }

      it { is_expected.to(route(:get, '/api/v1/users/passwords/new').to(action: :new)) }
      it { is_expected.to(respond_with(:no_content)) }
    end

    describe 'with invalid params' do
      let(:user) { create(:user) }
      let(:attributes) { { email: '', reset_password_url: '' } }

      before { get :new, params: attributes }

      it { is_expected.to(respond_with(:unprocessable_entity)) }

      it 'response has invalid email error' do
        error_details = JSON.parse(response.body)['errors'].map{|e| e['detail'] }

        expect(error_details).to include('Invalid Email')
      end

      it 'response has invalid reset_password_url error' do
        error_details = JSON.parse(response.body)['errors'].map{|e| e['detail'] }

        expect(error_details).to include('Invalid Reset password url')
      end
    end

    describe 'with invalid user email' do
      let(:user) { create(:user) }
      let(:attributes) { { email: Faker::Internet.email, reset_password_url: Faker::Internet.url } }

      before { get :new, params: attributes }

      it { is_expected.to(respond_with(:not_found)) }
    end

    it { is_expected.to(use_before_action(:validate_email_and_reset_password_url)) }
  end

  context 'POST create' do
    let(:user) { create(:user, reset_password_token_sent_at: Time.now) }
    let(:password) { Faker::Internet.password(min_length: 6) }

    describe 'with valid params' do
      let(:attributes) { { password: password,
                           password_confirmation: password,
                           reset_password_token: user.reset_password_token,
                           reset_password_token_sent_at: Time.now } }

      before { post :create, params: { data: { attributes: attributes } } }

      let(:attributes) { { password: password,
                           password_confirmation: password,
                           reset_password_token: user.reset_password_token } }

      it { is_expected.to(respond_with(:no_content)) }
    end

    describe 'with invalid reset_password_token' do
      let(:attributes) { { password: password,
                           password_confirmation: password,
                           reset_password_token: attributes_for(:user)[:reset_password_token] } }

      before { post :create, params: { data: { attributes: attributes } } }

      it { is_expected.to(respond_with(:not_found)) }
    end

    describe 'with reset_password_token expired' do
      let(:user) { create(:user, reset_password_token_sent_at: 20.years.ago) }
      let(:attributes) { { password: password,
                           password_confirmation: password,
                           reset_password_token: user.reset_password_token } }

      before { post :create, params: { data: { attributes: attributes } } }

      it { is_expected.to(respond_with(:not_found)) }
    end

    describe 'with unconfirmed password' do
      let(:attributes) { { password: password,
                           password_confirmation: Faker::Internet.password,
                           reset_password_token: user.reset_password_token,
                           reset_password_token_sent_at: Time.now } }

      before { post :create, params: { data: { attributes: attributes } } }

      it { is_expected.to(respond_with(:unprocessable_entity)) }
    end

    it { is_expected.to(route(:post, '/api/v1/users/passwords')
                          .to(action: :create, controller: 'api/v1/users/passwords')) }
  end

  context 'PUT update with user not authenticate' do
    let(:user) { create(:user) }
    let(:password) { Faker::Internet.password(min_length: 6) }

    describe 'when update password' do
      before { put :update, params: { id: user.id, data: { attributes: { password: 'password' } } } }

      it { is_expected.to(respond_with(:unauthorized)) }
    end
  end

  context 'PUT user create and authenticate new password' do
    let(:password) { Faker::Internet.password(min_length: 6) }
    let(:user) { create(:user, password: password, password_confirmation: password) }
    before { allow(subject).to receive(:current_user).and_return(user) }
    before { Authentication.with_user_token(@request, user) }

    describe 'with a new user password' do
      let(:new_password) { Faker::Internet.password(min_length: 6) }
      before { put :update, params: { id: user.id, data: { attributes: { current_password: password,
                                                            password: new_password,
                                                            password_confirmation: new_password } } } }
      before { Authentication.with_user_token(@request, user) }

      it "authenticate with new user's password" do
        expect(user.authenticate(new_password)).to eq(user)
      end

      it 'sign in user with new password' do
        authorization_token = response.headers[AuthorizableConcern::ACCESS_TOKEN_NAME]

        expect(authorization_token).to be_present
      end
      it { is_expected.to route(:put, "/api/v1/users/passwords/#{user.id}").to(action: 'update', id: user.id) }
      it { is_expected.to(respond_with(:ok)) }
    end
  end
end
