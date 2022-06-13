require 'rails_helper'

RSpec.describe Api::V1::Users::PaymentGatewayNotificationsController, type: :controller do
  context 'with bearer authentication' do
    before { post :create }

    it { is_expected.to(respond_with(:unauthorized)) }
  end

  context 'with bearer authentication' do
    let(:item) { build(:item, product: build(:product, profile: build(:profile))) }
    let(:order) { build(:order, items: [item]) }
    let(:payment_transaction) { create(:payment_transaction, :with_status_unpaid, payable: order) }
    let(:params) { { payment_block_notification: { transaction_code: payment_transaction.transaction_code } } }

    before { Authentication.with_payment_gateway_key(@request) }
    before { post :create, params: params }

    it { is_expected.to(use_before_action(:authenticate_payment_gateway_key!)) }
    it { is_expected.to(respond_with(:no_content)) }
    it { is_expected.to(route(:post, '/api/v1/users/payment_gateway_notifications').to(action: :create)) }
  end
end
