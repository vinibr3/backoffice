require 'rails_helper'

RSpec.describe Api::V1::Users::AddressesController, type: :controller do
  describe 'with user not authenticated' do
    let(:address) { create(:address) }

    context 'when create address' do
      before { post :create, params: { data: { attributes: address  } } }

      it { is_expected.to route(:post, '/api/v1/users/address').to(action: 'create') }
      it { is_expected.to(respond_with(:unauthorized)) }
    end
  end

  describe 'with authenticate user' do
    let(:address) { create(:address) }
    let(:user) { create(:user) }
    before { Authentication.with_user_token(@request, user) }
    before { allow(subject).to receive(:current_user).and_return(user) }

    context 'when create address with valid attributes' do
      let(:address) { create(:address) }
      before { post :create, params: { data: { attributes: address } } }

      it 'create address' do
        expect(address).to be_valid
      end

      it { is_expected.to route(:post, '/api/v1/users/address').to(action: 'create') }
      it { is_expected.to respond_with(:ok) }
    end

    context 'when create address with invalid attributes' do
      before { post :create, params: { data: { attributes: { zipcode: Faker::Alphanumeric.alpha(number: 256) } } } }

      it 'create address.zipcode with max length' do
        errors = JSON.parse(response.body)['errors'].map { |e| e['detail'] }
        expect(errors).to include('Zipcode is too long (maximum is 255 characters)')
      end

      it { is_expected.to(respond_with(:unprocessable_entity)) }
    end
  end

  describe 'with user not authenticated' do
    let(:address) { create(:address) }

    context 'when update address' do
      before { put :update, params: { data: { attributes: address } } }

      it { is_expected.to route(:put, '/api/v1/users/address').to(action: 'update') }
      it { is_expected.to(respond_with(:unauthorized)) }
    end
  end

  describe 'with authenticate user' do
    let(:address) { create(:address) }
    let(:user) { address.addressable }

    before { Authentication.with_user_token(@request, user) }
    before { allow(subject).to receive(:current_user).and_return(user) }

    context 'when update address with valid attributes' do
      let(:zipcode) { Faker::Address.zip_code }
      before { put :update, params: { data: { attributes: { street: zipcode } } } }

      it 'update zipcode' do
        expect(user.address['street']).to eq(zipcode)
      end

      it { is_expected.to route(:put, '/api/v1/users/address').to(action: 'update') }
      it { is_expected.to respond_with(:ok) }
    end

    context 'when update zipcode with invalid attributes' do
      before { put :update, params: { data: { attributes: { zipcode: Faker::Alphanumeric.alpha(number: 256) } } } }

      it 'update zipcode with max length' do
        errors = JSON.parse(response.body)['errors'].map { |e| e['detail'] }
        expect(errors).to include('Zipcode is too long (maximum is 255 characters)')
      end

      it { is_expected.to(respond_with(:unprocessable_entity)) }
    end

    describe 'Attachment' do
      it 'attach a document to address' do
        user.address.proove.attach(io: File.open('spec/support/assets/photo.jpeg'), filename: 'photo.jpeg', content_type: 'image/jpeg')
        expect(user.address.proove).to be_attached
      end
    end
  end
end
