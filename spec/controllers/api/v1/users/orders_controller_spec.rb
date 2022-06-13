require 'rails_helper'

RSpec.describe Api::V1::Users::OrdersController, type: :controller do
  describe 'POST create' do
    context 'with user authenticated' do
      let(:currency) { create(:currency, :with_valid_initials) }
      let(:payment_method) { create(:payment_method, :with_valid_code, currency: currency) }
      let(:items) { [{ quantity: Faker::Number.between(from: 1, to: 10), product_id: create(:product).id },
                     { quantity: Faker::Number.between(from: 1, to: 10), product_id: create(:product).id }] }
      let(:user) { create(:user) }
      let(:attributes) { { attributes: { payment_method_id: payment_method.id, items: items, user: user } } }

      before { Authentication.with_user_token(@request) }
      before { post :create, params: { data: attributes } }

      it { is_expected.to(route(:post, '/api/v1/users/orders').to(action: :create)) }
      it { is_expected.to(respond_with(:ok)) }

      it 'return orders' do
        expect(response).to be_jsonapi_data_of_type('orders')
      end
    end

    context 'with user not authenticated' do
      before { post :create }

      it { is_expected.to(respond_with(:unauthorized)) }
    end
  end

  describe 'GET show' do
    let(:order) { create(:order) }

    context 'with user authenticated' do
      before { Authentication.with_user_token(@request) }
      before { get :show, params: { id: order.id } }

      it { is_expected.to(route(:get, "/api/v1/users/orders/#{order.id}").to(action: :show, id: order.id)) }
      it { is_expected.to(respond_with(:ok)) }

      it 'return order' do
        expect(response).to be_jsonapi_data_of_type('orders')
      end

      it 'return order per id' do
        data = JSON.parse(response.body)['data']

        expect(data['id']).to eq(order.id.to_s)
      end
    end

    context 'with user not authenticated' do
      before { get :show, params: { id: order.id } }

      it { is_expected.to(respond_with(:unauthorized)) }
    end
  end
end
