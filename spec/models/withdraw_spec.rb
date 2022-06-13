require 'rails_helper'

RSpec.describe Withdraw, type: :model do
  let(:withdraw) { build(:withdraw) }
  let(:amount) { Faker::Number.number(digits: 10) }

  it 'has a valid factory' do
    expect(withdraw).to be_valid
  end

  context 'when assign gross_amount' do
    let(:withdraw) { build(:withdraw, gross_amount: amount) }

    it 'saves as multiple of 1e8' do
      expect(withdraw[:gross_amount]).to eq((amount.to_f * 1e8).to_i)
    end

    it 'return as decimal of 1e8' do
      expect(withdraw.gross_amount).to eq(amount)
    end
  end

  context 'when assign net_amount' do
    let(:withdraw) { build(:withdraw, net_amount: amount) }

    it 'saves as multiple of 1e8' do
      expect(withdraw[:net_amount]).to eq((amount.to_f * 1e8).to_i)
    end

    it 'return as decimal of 1e8' do
      expect(withdraw.net_amount).to eq(amount)
    end
  end

  context 'when assign fee' do
    let(:withdraw) { build(:withdraw, fee: amount) }

    it 'saves as multiple of 1e8' do
      expect(withdraw[:fee]).to eq((amount.to_f * 1e8).to_i)
    end

    it 'return as decimal of 1e8' do
      expect(withdraw.fee).to eq(amount)
    end
  end

  context 'when assign receivable_currency_amount' do
    let(:withdraw) { build(:withdraw, receivable_currency_amount: amount) }

    it 'saves as multiple of 1e8' do
      expect(withdraw[:receivable_currency_amount]).to eq((amount.to_f * 1e8).to_i)
    end

    it 'return as decimal of 1e8' do
      expect(withdraw.receivable_currency_amount).to eq(amount)
    end
  end

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:currency) }
  it { is_expected.to belong_to(:receivable_method) }
  it { is_expected.to have_many(:financial_transactions) }
  it { is_expected.to validate_presence_of(:gross_amount) }
  it { is_expected.to validate_presence_of(:net_amount) }
  it { is_expected.to validate_presence_of(:receivable_currency_amount) }
  it { is_expected.to define_enum_for(:status).with_values %w[created confirmation paying paid canceled] }
end
