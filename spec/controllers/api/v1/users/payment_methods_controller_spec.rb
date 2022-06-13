require 'rails_helper'

RSpec.describe Api::V1::Users::PaymentMethodsController, type: :controller do
  context 'without user authentication' do
    before { get :index }

    it { is_expected.to(respond_with(:unauthorized)) }
  end

  context 'with user authentication' do
    before { Authentication.with_user_token(@request) }
    before { create(:payment_method) }
    before { get :index }

    it { is_expected.to(route(:get, '/api/v1/users/payment_methods').to(action: :index)) }
    it { is_expected.to(respond_with(:ok)) }

    it 'return payment_methods' do
      expect(response).to be_jsonapi_array_of_type('payment_methods')
    end
  end
end
