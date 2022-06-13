require 'rails_helper'

RSpec.describe FinancialReason, type: :model do
  let(:financial_reason) { build(:financial_reason) }

  it 'has a valid factory' do
    expect(financial_reason).to be_valid
  end

  it 'has a defaul value of truthy' do
    expect(financial_reason.active).to be_truthy
  end

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_length_of(:title).is_at_most(255) }
  it { is_expected.to validate_presence_of(:code) }
  it { is_expected.to validate_uniqueness_of(:code) }
  it { is_expected.to have_db_index(:code) }
  it { is_expected.to have_many(:bonus_commissions) }
  it { is_expected.to have_many(:financial_transactions) }
end
