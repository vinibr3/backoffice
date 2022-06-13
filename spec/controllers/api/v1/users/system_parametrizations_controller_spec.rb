require 'rails_helper'

RSpec.describe Api::V1::Users::SystemParametrizationsController, type: :controller do
  context 'GET index' do
    describe 'with authenticate_bearer_token' do
      before { Authentication.with_bearer_token(@request) }
      before { get :index }

      it { is_expected.to(route(:get, '/api/v1/users/system_parametrizations').to(action: :index))}
      it { is_expected.to(respond_with(:ok)) }
      it { is_expected.to(use_before_action(:authenticate_bearer_token!)) }

      it 'render system parametrizations' do
        types = JSON.parse(response.body)['data'].map {|s| s['type']}

        expect(types).to all eq('system_parametrizations')
      end
    end
  end

  describe 'without authenticate_bearer_token' do
    before { get :index }

    it { is_expected.to(respond_with(:unauthorized)) }
  end
end
