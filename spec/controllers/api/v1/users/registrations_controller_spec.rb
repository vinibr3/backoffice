require 'rails_helper'

RSpec.describe Api::V1::Users::RegistrationsController, type: :controller do

  context 'POST create' do

    let(:user) { create(:user) }
    let(:password) { Faker::Internet.password(min_length: 6) }
    let(:sign_in_attributes) { SystemParametrization.current.sign_in_attributes }
    let(:attributes) { attributes_for(:user).slice(*sign_in_attributes.map(&:to_sym))
                                            .merge(registration_confirmation_url: Faker::Internet.url,
                                                   sponsor_token: user.sponsor_token,
                                                   password: password,
                                                   password_confirmation: password) }

    before do
      create(:profile)
      Authentication.with_bearer_token(@request)
    end

    describe 'when valid params' do
      before { get :create, params: { data: { attributes: attributes } } }

      it { is_expected.to(route(:post, '/api/v1/users/registrations').to(action: 'create')) }
      it { is_expected.to(respond_with(:ok)) }

      it 'sign in created user' do
        authorization_token = response.headers[AuthorizableConcern::ACCESS_TOKEN_NAME]

        expect(authorization_token).to be_present
      end

       it 'assign user with first profile' do
         data = JSON.parse(response.body)
         assined_profile = data.dig('data', 'relationships', 'profile', 'data')

         expect(assined_profile).to be_present
       end
    end

    describe 'when invalid params' do
      context 'with password unconfirmated' do
        before { get :create, params: { data: { attributes: attributes.merge(password_confirmation: Faker::Internet.password) } } }

        it { is_expected.to(respond_with(:unprocessable_entity)) }
      end
    end

    describe 'when mandatory registration confirmation' do
      before { SystemParametrization.current.update!(user_confirmable_on_register: true) }

      context 'with registration confirmation url' do
        before { get :create, params: { data: { attributes: attributes } } }

        it do
          is_expected.to(respond_with(:ok))
        end
      end

      context 'without registration confirmation url' do

        before { get :create, params: { data: { attributes: attributes.merge(registration_confirmation_url: '') } } }

        it { is_expected.to(respond_with(:unprocessable_entity)) }
      end
    end

    describe 'when mandatory register with sponsor token' do
      before { SystemParametrization.current.update!(mandatory_register_with_sponsor_token: true) }

      context 'with sponsor token' do
        before { get :create, params: { data: { attributes: attributes.merge(sponsor_token: user.sponsor_token) } } }

        it { is_expected.to(respond_with(:ok)) }
      end

      context 'without sponsor token' do
        before { post :create, params: { data: { attributes: attributes.merge(sponsor_token: '') } } }

        it { is_expected.to(respond_with(:unprocessable_entity)) }

        it 'return invalid sponsor token error' do
          errors = JSON.parse(response.body)['errors'].map { |e| e['detail'] }

          expect(errors).to include('Invalid Sponsor token')
        end
      end
    end

    it { is_expected.to(use_before_action(:validate_registration_confirmation_url)) }
    it { is_expected.to(use_before_action(:validate_presence_of_sponsor_token)) }
  end
end
