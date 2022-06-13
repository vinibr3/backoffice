require 'rails_helper'

RSpec.describe BonusCommission, type: :model do
  let(:bonus_commission) { build(:bonus_commission) }

  it 'has a valid factory' do
    expect(bonus_commission).to be_valid
  end

  it { is_expected.to validate_presence_of(:generation) }
  it { is_expected.to validate_numericality_of(:generation) }
  it { is_expected.to validate_presence_of(:percentage) }
  it { is_expected.to validate_numericality_of(:percentage) }
  it { is_expected.to belong_to(:financial_reason) }
end
