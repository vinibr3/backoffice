require 'rails_helper'

RSpec.describe Api::V1::Users::WithdrawsController, type: :controller do
  describe 'POST create' do
    it { is_expected.to(route(:post, '/api/v1/users/withdraws').to(action: :create)) }
    it { is_expected.to(use_before_action(:authenticate!)) }

    context 'when do not authenticate user' do
      before { post :create }

      it { is_expected.to(respond_with(:unauthorized)) }
    end

    context 'when authenticate user' do
      let(:currencies) { Currency::INITIALS.values.map { |i| create(:currency, initials: i) } }
      let(:currency) { currencies.sample }
      let(:user) { create(:user) }
      let(:gross_amount) { Faker::Number.positive.round(8) }
      let(:receivable_method) { create([:bank_account, :wallet, :pix].sample, currency: currencies.sample) }
      let(:confirmation_url) { Faker::Internet.url }
      let(:data) { { data: { attributes: { currency_id: currency.id,
                                           receivable_method_id: receivable_method.id,
                                           receivable_method_type: receivable_method.class.name,
                                           gross_amount: gross_amount,
                                           confirmation_url: confirmation_url } } } }

      before { Authentication.with_user_token(@request, user) }
      before { post :create, params: data }

      it { is_expected.to(respond_with(:ok)) }

      context 'when gross_amount less than minimum_amount' do
        before { WithdrawParametrization.current(currency).update!(minimum_amount: gross_amount + 1) }
        before { post :create, params: data }

        it { is_expected.to(respond_with(:unprocessable_entity)) }
      end
    end
  end

  describe 'GET index' do
    it { is_expected.to(route(:get, '/api/v1/users/withdraws').to(action: :index)) }
    it { is_expected.to(use_before_action(:authenticate!)) }

    context 'when do not authenticate user' do
      before { get :index }

      it { is_expected.to(respond_with(:unauthorized)) }
    end

    context 'when authenticate user' do
      let(:user) { create(:user) }
      let(:currencies) { Currency::INITIALS.values.map { |i| create(:currency, initials: i) } }
      let(:currency) { currencies.sample }

      before { Authentication.with_user_token(@request, user) }
      before { 25.times { create(:withdraw, receivable_method: create([:bank_account, :wallet, :pix].sample), user: user) } }
      before { get :index }

      it { is_expected.to(respond_with(:ok)) }

      it 'return jsonapi array of type withdraws' do
        expect(response).to be_jsonapi_array_of_type('withdraws')
      end

      context 'with statues query param present' do
        let(:statuses) { Withdraw.pluck(:status).uniq }
        let(:sample_statuses) { statuses.sample((1..statuses.size).to_a.sample) }

        before { get :index, params: { statuses: sample_statuses } }

        it 'return withdraws filtered by statuses' do
          uniq_statuses = JsonApiHelper.map_attribute('status', response).uniq

          expect(uniq_statuses.sort).to eq(sample_statuses.sort)
        end
      end

      context 'with currency_ids query param present' do
        let(:currency_ids) { Withdraw.pluck(:currency_id) }
        let(:currency_ids_sample) { currency_ids.sample((1..currency_ids.size).to_a.sample) }

        before { get :index, params: { currency_ids: currency_ids_sample } }

        it 'return withdraws filtered by currency_ids' do
          uniq_currency_ids = JsonApiHelper.relationship_ids('currency', response).uniq

          expect(uniq_currency_ids.sort).to eq(currency_ids_sample.map(&:to_s).sort)
        end
      end

      context 'with receivable_method_types query param present' do
        let(:receivable_method_types) { Withdraw.pluck(:receivable_method_type).uniq }
        let(:receivable_method_types_sample) { receivable_method_types.sample((1..receivable_method_types.size).to_a.sample) }

        before { get :index, params: { receivable_method_types: receivable_method_types_sample } }

        it 'return withdraws filtered by receivable_method_type' do
          uniq_types = JsonApiHelper.map_attribute('receivable_method_type', response).uniq

          expect(uniq_types.sort).to eq(receivable_method_types_sample.sort)
        end
      end

      context 'with created_at_from query param present' do
        let(:date) { 5.days.ago }
        let(:created_at) { date + 4.day }
        let(:withdraw) { create(:withdraw, user: user) }

        before do
          Withdraw.all.update_all(created_at: date)
          Withdraw.where(id: withdraw.id).update_all(created_at: Time.now)
        end

        before { get :index, params: { created_at_from: created_at } }

        it 'return withdraws filtered by created_at_from' do
          withdraw_ids = JsonApiHelper.map_id_and_type(response).map(&:first)

          expect(withdraw_ids).to eq([withdraw.id.to_s])
        end
      end

      context 'with created_at_until query param present' do
        let(:date) { 5.days.from_now }
        let(:created_at) { date - 4.day }
        let(:withdraw) { create(:withdraw, user: user) }

        before do
          Withdraw.all.update_all(created_at: date)
          Withdraw.where(id: withdraw.id).update_all(created_at: Time.now)
        end

        before { get :index, params: { created_at_until: created_at } }

        it 'return withdraws filtered by created_at_until' do
          withdraw_ids = JsonApiHelper.map_id_and_type(response).map(&:first)

          expect(withdraw_ids).to eq([withdraw.id.to_s])
        end
      end
    end
  end
end
