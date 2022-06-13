require 'rails_helper'

RSpec.describe Api::V1::Users::ProductsController, type: :controller do
  before { Authentication.with_user_token(@request) }
  before { 30.times { create(:product) } }
  before { get :index }

  it { is_expected.to(route(:get, '/api/v1/users/products').to(action: :index) ) }
  it { is_expected.to(respond_with(:ok)) }

  it 'return array of type products' do
    expect(response).to be_jsonapi_array_of_type('products')
  end
end
