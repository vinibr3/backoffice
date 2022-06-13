require 'rails_helper'

RSpec.describe Wallet, type: :model do
  let(:wallet) { build(:wallet) }

  it 'has a valid factory' do
    expect(wallet).to be_valid
  end

  it 'has default truthy value' do
    expect(wallet.active).to be_truthy
  end

  it { is_expected.to validate_presence_of(:secret_hash) }
  it { is_expected.to validate_length_of(:secret_hash).is_at_most(255) }
  it { is_expected.to belong_to(:currency) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:withdraws) }
end
