require 'rails_helper'

RSpec.describe Api::V1::Users::FinancialTransactionsController, type: :controller do
  describe 'GET index' do
    context 'when authenticate user' do
      let(:user) { create(:user) }
      let(:currency) { create(:currency, initials: 'ADF') }
      let(:currency2) { create(:currency, initials: 'DDT') }
      before { 10.times { create(:financial_transaction, currency: [currency, currency2].sample,
                                                         user: user,
                                                         user_cashflow: [:in, :out].sample) } }
      before { Authentication.with_user_token(@request, user) }
      before { get :index }

      it { is_expected.to(route(:get, '/api/v1/users/financial_transactions').to(action: :index)) }
      it { is_expected.to(respond_with(:ok)) }
      it { is_expected.to(use_before_action(:authenticate!)) }

      context 'with financial_reason_id param' do
        let(:financial_reason) { FinancialReason.first }
        let(:financial_reason_ids) { JsonApiHelper.relationship_ids('financial_reason', response) }

        before { get :index, params: { financial_reason_id: financial_reason.id } }

        it 'return any financial_transaction' do
          expect(financial_reason_ids).to be_any
        end

        it 'return financial_transactions with financial_reason_id only' do
          expect(financial_reason_ids).to all eq(financial_reason.id.to_s)
        end
      end

      context 'with currency_id param' do
        let(:currency_ids) { JsonApiHelper.relationship_ids('currency', response) }

        before { get :index, params: { currency_id: currency.id } }

        it 'return any financial_transaction' do
          expect(currency_ids).to be_any
        end

        it 'return financial_transactions per currency_id' do
          expect(currency_ids).to all eq(currency.id.to_s)
        end
      end

      context 'with bonus_commission_id param' do
        let(:bonus_commission) { BonusCommission.last }
        let(:bonus_commission_ids) { JsonApiHelper.relationship_ids('bonus_commission', response) }

        before { get :index, params: { bonus_commission_id: bonus_commission.id } }

        it 'return any financial_transaction' do
          expect(bonus_commission_ids).to be_any
        end

        it 'return financial_transactions per bonus_commission_id' do
          expect(bonus_commission_ids).to all eq(bonus_commission.id.to_s)
        end
      end

      context 'with order_id param' do
        let(:order) { create(:order, currency: currency) }
        let(:order_ids) { JsonApiHelper.relationship_ids('order', response) }

        before { create(:financial_transaction, order: order, user_cashflow: [:in, :out].sample, user: user) }
        before { get :index, params: { order_id: order.id } }

        it 'return any financial_transaction' do
          expect(order_ids).to be_any
        end

        it 'return financial_transactions per order_id' do
          expect(order_ids).to all eq(order.id.to_s)
        end
      end

      context 'with product_id param' do
        let(:product) { Product.first }
        let(:product_ids) { JsonApiHelper.relationship_ids('product', response) }

        before { get :index, params: { product_id: product.id } }

        it 'return any financial_transaction' do
          expect(product_ids).to be_any
        end

        it 'return financial_transactions per product_id' do
          expect(product_ids).to all eq(product.id.to_s)
        end
      end

      context 'with spreader_user_uniq_attribute param' do
        let(:spreader_user) { FinancialTransaction.last.spreader_user }
        let(:spreader_user_ids) { JsonApiHelper.relationship_ids('spreader_user', response) }
        let(:attribute) { spreader_user.read_attribute(SystemParametrization.current.sign_in_attributes.sample.to_sym) }

        before { get :index, params: { spreader_user_uniq_attribute: attribute } }

        it 'return any financial_transaction' do
          expect(spreader_user_ids).to be_any
        end

        it 'return financial_transactions per spreader_user_uniq_attribute' do
          expect(spreader_user_ids).to all eq(spreader_user.id.to_s)
        end
      end
    end

    context 'when do not authenticate user' do
      before { get :index }

      it { is_expected.to(respond_with(:unauthorized)) }
    end
  end
end
