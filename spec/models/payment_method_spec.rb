require 'rails_helper'

RSpec.describe PaymentMethod, type: :model do
  let(:payment_method) { build(:payment_method) }

  it 'has a valid factory' do
    expect(payment_method).to be_valid
  end

  it 'has a defaul value of truthy' do
    expect(payment_method.active).to be_truthy
  end

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_most(255) }
  it { is_expected.to validate_presence_of(:code) }
  it { is_expected.to validate_uniqueness_of(:code) }
  it { is_expected.to validate_length_of(:code).is_at_most(255) }
  it { is_expected.to belong_to(:currency) }
end
