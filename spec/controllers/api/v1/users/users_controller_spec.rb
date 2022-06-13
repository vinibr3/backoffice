require 'rails_helper'

RSpec.describe Api::V1::Users::UsersController, type: :controller do
  describe 'with user not authenticated' do
    let(:user) { create(:user) }

    context 'when update user' do
      before { put :update, params: { data: { attributes: { name: 'name' } } } }

      it { is_expected.to route(:put, '/api/v1/users/users').to(action: 'update') }
      it { is_expected.to(respond_with(:unauthorized)) }
    end
  end

  describe 'with authenticate user' do
    let(:user) { create(:user) }
    before { Authentication.with_user_token(@request, user) }
    before { allow(subject).to receive(:current_user).and_return(user) }

    context 'when update name with valid attributes' do
      let(:name) { Faker::Name.name }
      before { put :update, params: { data: { attributes: { name: name } } } }

      it 'update name' do
        expect(user['name']).to eq(name)
      end

      it { is_expected.to route(:put, '/api/v1/users/users').to(action: 'update') }
      it { is_expected.to respond_with(:ok) }
    end

    context 'when update name with invalid attributes' do
      before { put :update, params: { data: { attributes: { name: Faker::Alphanumeric.alpha(number: 256) } } } }

      it 'update name with max length' do
        errors = JSON.parse(response.body)['errors'].map { |e| e['detail'] }
        expect(errors).to include('Name is too long (maximum is 255 characters)')
      end

      it { is_expected.to(respond_with(:unprocessable_entity)) }
    end

    context 'when update email with valid attributes' do
      let(:email) { Faker::Internet.email }
      before { put :update, params: { data: { attributes: { email: email } } } }

      it 'update email' do
        expect(user['email']).to eq(email)
      end

      it { is_expected.to respond_with(:ok) }
    end

    context 'when update email with invalid attributes' do
      before { put :update, params: { data: { attributes: { email: "test" } } } }

      it { is_expected.to(respond_with(:unprocessable_entity)) }
    end

    context 'when update document with valid attributes' do
      let(:document) { Faker::IDNumber.valid }
      before { put :update, params: { data: { attributes: { document: document } } } }

      it 'update document' do
        expect(user['document']).to eq(document)
      end

      it { is_expected.to respond_with(:ok) }
    end

    context 'when update document with invalid attributes' do
      before { put :update, params: { data: { attributes: { document: Faker::Number.number(digits: 256) } } } }

      it { is_expected.to(respond_with(:unprocessable_entity)) }
    end

    context 'when update birthdate with valid attributes' do
      let(:birthdate) { Faker::Date.backward(days: Faker::Number.positive.to_i) }
      before { put :update, params: { data: { attributes: { birthdate: birthdate } } } }

      it 'update birthdate' do
        expect(user['birthdate']).to eq(birthdate)
      end

      it { is_expected.to respond_with(:ok) }
    end

    context 'when update gender with valid attributes' do
      let(:gender) { User::genders.keys.sample }
      before { put :update, params: { data: { attributes: { gender: gender } } } }

      it 'update gender' do
        expect(user['gender']).to eq(gender)
      end

      it { is_expected.to respond_with(:ok) }
    end

    context 'when update cellphone with valid attributes' do
      let(:cellphone) { Faker::PhoneNumber.cell_phone }
      before { put :update, params: { data: { attributes: { cellphone: cellphone } } } }

      it 'update cellphone' do
        expect(user['cellphone']).to eq(cellphone)
      end

      it { is_expected.to respond_with(:ok) }
    end

    context 'when update cellphone with invalid attributes' do
      before { put :update, params: { data: { attributes: { cellphone: Faker::Number.number(digits: 256) } } } }

      it { is_expected.to(respond_with(:unprocessable_entity)) }
    end

    context 'when update facebook with valid attributes' do
      let(:facebook) { Faker::Name.first_name }
      before { put :update, params: { data: { attributes: { facebook: facebook } } } }

      it 'update facebook' do
        expect(user['facebook']).to eq(facebook)
      end

      it { is_expected.to respond_with(:ok) }
    end

    context 'when update instagram with valid attributes' do
      let(:instagram) { Faker::Name.first_name }
      before { put :update, params: { data: { attributes: { instagram: instagram } } } }

      it 'update instagram' do
        expect(user['instagram']).to eq(instagram)
      end

      it { is_expected.to respond_with(:ok) }
    end

    context 'when update twitter with valid attributes' do
      let(:twitter) { Faker::Name.first_name }
      before { put :update, params: { data: { attributes: { twitter: twitter } } } }

      it 'update twitter' do
        expect(user['twitter']).to eq(twitter)
      end

      it { is_expected.to respond_with(:ok) }
    end

    describe 'Attachment' do
      it 'attach a document to user' do
        user.document_proove.attach(io: File.open('spec/support/assets/photo.jpeg'), filename: 'photo.jpeg', content_type: 'image/jpeg')
        expect(user.document_proove).to be_attached
      end
    end
  end
end
