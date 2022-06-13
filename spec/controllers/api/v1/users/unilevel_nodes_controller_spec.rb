require 'rails_helper'

RSpec.describe Api::V1::Users::UnilevelNodesController, type: :controller do
  describe 'GET index' do
    it { is_expected.to(route(:get, '/api/v1/users/unilevel_nodes').to(action: :index)) }
    it { is_expected.to(use_before_action(:authenticate!)) }

    context 'when not authenticate user' do
      before { get :index }

      it { is_expected.to(respond_with(:unauthorized)) }
    end

    context 'when authenticate user' do
      let(:user) { create(:user) }

      before { UnilevelNodeTree.create(user) }
      before { Authentication.with_user_token(@request, user) }
      before { get :index, params: { unilevel_node_id: user.unilevel_node.id } }

      it { is_expected.to(respond_with(:ok)) }

      it 'render unilevel_nodes' do
        expect(response).to be_jsonapi_array_of_type('unilevel_nodes')
      end

      describe 'with query params' do
        let(:unique_key) { user.sponsoreds.pluck(*SystemParametrization.current.sign_in_attributes).flatten.compact.first }
        let(:key) { User.pluck(:email).shuffle.first }
        let(:params) { { active: Faker::Boolean.boolean,
                         inactive: Faker::Boolean.boolean,
                         created_at_from: 10.days.ago.to_s,
                         created_at_until: 10.days.from_now.to_s,
                         maximum_generation: (1..10).to_a.sample,
                         unique_key: unique_key,
                         unilevel_node_id: user.unilevel_node.id
                       }.except(Faker::Boolean.boolean ? :active : '')
                        .except(Faker::Boolean.boolean ? :inactive : '')
                        .except(Faker::Boolean.boolean ? :created_at_from : '')
                        .except(Faker::Boolean.boolean ? :created_at_until : '')
                        .except(Faker::Boolean.boolean ? :maximum_generation : '')
                        .except(Faker::Boolean.boolean ? :unique_key : '') }
        before { get :index, params: [params, params.merge(generation: 1)].sample }

        it 'render unilevel_nodes' do
          expect(response).to be_jsonapi_array_of_type('unilevel_nodes')
        end
      end
    end
  end
end
