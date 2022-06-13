require 'rails_helper'

RSpec.describe SystemParametrization, type: :model do
  let(:system_parametrization) { build(:system_parametrization) }

  it 'has a valid factory' do
    expect(system_parametrization).to be_valid
  end

  it "has email as default 'registration_attribute'" do
    expect(SystemParametrization.new.registration_attribute).to eq('email')
  end

  describe 'when assign sign_in_attributes' do
    context 'with valid values' do
      let(:system_parametrization) { build(:system_parametrization, :with_valid_sign_attributes) }

      it 'system_parametrization is valid' do
        expect(system_parametrization).to be_valid
      end
    end

    context 'with invalid values' do
      let(:system_parametrization) { build(:system_parametrization, :with_invalid_sign_attributes) }

      it 'system_parametrization is invalid' do
        expect(system_parametrization).to be_invalid
      end
    end
  end

  describe 'validates inclusion of registration_attribute' do
    context 'with valid registration_attribute' do
      let(:registration_attribute) { build(:system_parametrization).sign_in_attributes.sample }
      let(:system_parametrization) { build(:system_parametrization, registration_attribute: registration_attribute) }

      it 'system_parametrization is valid' do
        expect(system_parametrization).to be_valid
      end
    end

    context 'with invalid registration_attribute' do
      let(:system_parametrization) { build(:system_parametrization, registration_attribute: Faker::Name.name.downcase) }

      it 'system_parametrization is invalid' do
        expect(system_parametrization).to be_invalid
      end
    end
  end

  it { is_expected.to(serialize(:sign_in_attributes).as(Array)) }
end
