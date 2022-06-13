require 'rails_helper'

RSpec.describe Deposit, type: :model do
  let(:deposit) { build(:deposit) }

  it 'has a valid factory' do
    expect(deposit).to be_valid
  end

  it { is_expected.to validate_numericality_of(:amount).is_greater_than(0) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:currency) }
  it { is_expected.to have_one(:payment_transaction) }
  it { is_expected.to have_one(:financial_transaction) }
end
