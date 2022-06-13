require 'rails_helper'

RSpec.describe Currency, type: :model do
  let(:currency) { build(:currency) }

  it 'has a valid factory' do
    expect(currency).to be_valid
  end

  describe 'when create currency' do
    let(:currency) { Currency.new }

    it 'has a default value falsey' do
      expect(currency.crypto).to be_falsey
    end

    it 'has a default value truthy' do
      expect(currency.active).to be_truthy
      expect(currency.order_payment_enabled).to be_truthy
      expect(currency.deposit_payment_enabled).to be_truthy
      expect(currency.withdraw_enabled).to be_truthy
      expect(currency.receivable_method_enabled).to be_truthy
    end
  end

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_most(255) }
  it { is_expected.to validate_presence_of(:initials) }
  it { is_expected.to validate_uniqueness_of(:initials) }
  it { is_expected.to validate_length_of(:name).is_at_most(255) }
  it { is_expected.to validate_presence_of(:scale) }
  it { is_expected.to validate_numericality_of(:scale) }
  it { is_expected.to have_many(:payment_methods) }
end
