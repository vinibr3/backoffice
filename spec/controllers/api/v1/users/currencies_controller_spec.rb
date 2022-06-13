require 'rails_helper'

RSpec.describe Api::V1::Users::CurrenciesController, type: :controller do
	context 'GET index' do
		describe 'when authenticate user' do
      before { Authentication.with_user_token(@request) }
  		before { 30.times { create(:currency, initials: Faker::Currency.unique.code) } }
  		before { get :index }

			it { is_expected.to(route(:get, '/api/v1/users/currencies').to(action: 'index')) }
			it { is_expected.to(use_before_action(:authenticate!)) }
			it { is_expected.to(respond_with(:ok)) }

			it 'return currencies as json api array' do
				expect(response).to be_jsonapi_array_of_type('currencies')
			end
		end

		describe 'when do not authenticate user' do
      before { get :index }

			it { is_expected.to(respond_with(:unauthorized)) }
		end
	end
end
