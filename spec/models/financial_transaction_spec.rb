require 'rails_helper'

RSpec.describe FinancialTransaction, type: :model do
  let(:financial_transaction) { build(:financial_transaction) }
  let(:amount) { Faker::Number.number(digits: 10) }

  it 'has a valid factory' do
    expect(financial_transaction).to be_valid
  end

  context 'when assign user_amount' do
    let(:financial_transaction) { build(:financial_transaction, user_amount: amount) }

    it 'saves as multiple of 1e8' do
      expect(financial_transaction[:user_amount]).to eq((amount.to_f * 1e8).to_i)
    end

    it 'return as decimal of 1e8' do
      expect(financial_transaction.user_amount).to eq(amount)
    end
  end

  context 'when assign system_amount' do
    let(:financial_transaction) { build(:financial_transaction, system_amount: amount) }

    it 'saves as multiple of 1e8' do
      expect(financial_transaction[:system_amount]).to eq((amount.to_f * 1e8).to_i)
    end

    it 'return as decimal of 1e8' do
      expect(financial_transaction.system_amount).to eq(amount)
    end
  end

  context 'when assign admin_amount' do
    let(:financial_transaction) { build(:financial_transaction, admin_amount: amount) }

    it 'saves as multiple of 1e8' do
      expect(financial_transaction[:admin_amount]).to eq((amount.to_f * 1e8).to_i)
    end

    it 'return as decimal of 1e8' do
      expect(financial_transaction.admin_amount).to eq(amount)
    end
  end

  it { is_expected.to validate_presence_of(:admin_cashflow) }
  it { is_expected.to define_enum_for(:admin_cashflow).with_values %w[not_applicable in out] }
  it { is_expected.to validate_presence_of(:system_cashflow) }
  it { is_expected.to define_enum_for(:system_cashflow).with_values %w[not_applicable in out] }
  it { is_expected.to validate_presence_of(:user_cashflow) }
  it { is_expected.to define_enum_for(:user_cashflow).with_values %w[not_applicable in out] }
  it { is_expected.to validate_numericality_of(:financial_result_code) }
  it { is_expected.to have_db_index(:financial_result_code) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:financial_reason) }
  it { is_expected.to belong_to(:currency) }
  it { is_expected.to belong_to(:product).optional }
  it { is_expected.to belong_to(:spreader_user).optional.class_name('User') }
  it { is_expected.to belong_to(:chargebacker_by_inactivity).optional.class_name('FinancialTransaction') }
  it { is_expected.to have_one(:chargeback_by_inactivity) }
  it { is_expected.to belong_to(:deposit).optional }
  it { is_expected.to belong_to(:withdraw).optional }
end
