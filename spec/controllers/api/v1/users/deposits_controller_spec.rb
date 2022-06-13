require 'rails_helper'

RSpec.describe Api::V1::Users::DepositsController, type: :controller do
  describe 'POST create' do
    context 'with user authenticated' do
      before { Authentication.with_user_token(@request) }
      before { post :create, params: data }

      let(:currencies) { Currency::INITIALS.values.map { |i| create(:currency, initials: i) } }
      let(:payment_method) { create(:payment_method, :with_valid_code, currency: currencies.sample) }
      let(:currency) { currencies.sample }
      let(:user) { create(:user) }
      let(:amount) { Faker::Number.positive }
      let(:data) { { data: { attributes: { amount: amount,
                                           currency_id: currency.id,
                                           payment_method_id: payment_method.id } } } }

      it { is_expected.to(route(:post, '/api/v1/users/deposits').to(action: :create)) }
      it { is_expected.to(respond_with(:ok)) }

      it 'return deposit' do
        expect(response).to be_jsonapi_data_of_type('deposits')
      end
    end

    context 'with user not authenticated' do
      before { post :create }

      it { is_expected.to(respond_with(:unauthorized)) }
    end
  end

  describe 'GET index' do
    context 'when user authenticated' do
      let(:user) { create(:user) }
      let(:payment_method) { create(:payment_method, :with_valid_code, currency: Currency.all.sample) }

      before { 1.times { create(:currency, :with_faker_initials) } }
      before { 1.times { create(:deposit, user: user,
                                          currency: Currency.all.sample,
                                          payment_transaction: create(:payment_transaction, payment_method: payment_method)) } }

      before { Authentication.with_user_token(@request, user) }
      before { get :index }

      it { is_expected.to(route(:get, '/api/v1/users/deposits').to(action: :index)) }
      it { is_expected.to(respond_with(:ok)) }

      it 'return deposits' do
        expect(response).to be_jsonapi_array_of_type('deposits')
      end

      context 'with currency_id query param' do
        let(:currency) { user.deposits.last.currency }

        before { get :index, params: { currency_id: currency.id } }

        it 'return deposits filtered per currency_id' do
          currency_ids = JsonApiHelper.relationship_ids('currency', response)

          expect(currency_ids).to eq([currency.id.to_s])
        end
      end

      context 'with payment_method_id query param' do
        before { get :index, params: { payment_method_id: user.deposits.last.payment_method.id } }

        it 'return deposits filtered per currency_id' do
          payment_method_ids = JsonApiHelper.relationship_ids('payment_method', response)

          expect(payment_method_ids).to eq([user.deposits.last.payment_method.id.to_s])
        end
      end

      context 'with payment_transaction_status query param' do
        let(:payment_transaction) { user.deposits.last.payment_transaction }

        before { get :index, params: { payment_transaction_status: payment_transaction.status } }

        it 'return deposits filtered per payment status' do
          payment_statuses =
            JsonApiHelper.relationship_attributes('payment_transaction', 'status', response)

          expect(payment_statuses).to be_any
          expect(payment_statuses).to all eq(payment_transaction.status)
        end
      end

      context 'with paid_at_from query param present' do
        let(:paid_at) { 2.days.ago }
        let(:deposit) { user.deposits.last }

        before { deposit.payment_transaction.update!(paid_at: paid_at - 1.day) }
        before { get :index, params: { paid_at_from: 3.days.ago } }

        it 'return deposits filtered per payment date' do
          deposit_ids = JSON.parse(response.body)['data'].map { |a| a['id'] }

          expect(deposit_ids).to eq([deposit.id.to_s])
        end
      end

      context 'with paid_at_until query param present' do
        let(:deposit) { user.deposits.last }

        before { deposit.payment_transaction.update!(paid_at: Time.now) }
        before { get :index, params: { paid_at_until: 3.days.from_now } }

        it 'return deposits filtered per payment date' do
          deposit_ids = JSON.parse(response.body)['data'].map { |a| a['id'] }

          expect(deposit_ids).to eq([deposit.id.to_s])
        end
      end

      context 'with created_at_from query param present' do
        let(:created_at) { 2.days.ago }
        let(:deposit) { user.deposits.last }

        before do
          Deposit.update_all(created_at: 100.year.ago)
          deposit.update!(created_at: created_at + 1.day)
        end

        before { get :index, params: { created_at_from: created_at.to_s} }

        it 'return deposits filtered per creation date' do
          deposit_ids = JSON.parse(response.body)['data'].map { |a| a['id'] }

          expect(deposit_ids).to eq([deposit.id.to_s])
        end
      end

      context 'with created_at_until query param present' do
        let(:deposit) { user.deposits.last }

        before do
          Deposit.update_all(created_at: 100.year.from_now)
          deposit.update!(created_at: 10.years.from_now)
        end
        before { get :index, params: { created_at_until: 20.years.from_now } }

        it 'return deposits filtered per creation date' do
          deposit_ids = JSON.parse(response.body)['data'].map { |a| a['id'] }

          expect(deposit_ids).to eq([deposit.id.to_s])
        end
      end
    end

    context 'when user do not authenticated' do
      before { get :index }

      it { is_expected.to(respond_with(:unauthorized)) }
    end
  end
end
