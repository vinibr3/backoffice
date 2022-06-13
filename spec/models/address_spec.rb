require 'rails_helper'

RSpec.describe Address, type: :model do
  let(:address) { build(:address) }

  it 'has a valid factory' do
    expect(address).to be_valid
  end

  it { is_expected.to validate_length_of(:zipcode).is_at_most(255) }
  it { is_expected.to validate_length_of(:street).is_at_most(255) }
  it { is_expected.to validate_length_of(:number).is_at_most(255) }
  it { is_expected.to validate_length_of(:complement).is_at_most(255) }
  it { is_expected.to validate_length_of(:district).is_at_most(255) }
  it { is_expected.to validate_length_of(:city).is_at_most(255) }
  it { is_expected.to validate_length_of(:state).is_at_most(255) }
  it { is_expected.to validate_length_of(:country).is_at_most(255) }
  it { is_expected.to belong_to(:addressable) }
end
