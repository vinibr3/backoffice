require 'rails_helper'

RSpec.describe Profile, type: :model do
  let(:profile) { build(:profile) }

  it 'has a valid factory' do
    expect(profile).to be_valid
  end

  it "has default truthy value" do
    expect(profile.active).to be_truthy
  end

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_most(255) }
  it { is_expected.to validate_presence_of(:trade_fee_percentage) }
  it { is_expected.to validate_numericality_of(:trade_fee_percentage) }
  it { is_expected.to validate_presence_of(:duration_days_per_purchase) }
  it { is_expected.to validate_numericality_of(:duration_days_per_purchase).is_greater_than(0) }
  it { is_expected.to validate_presence_of(:duration_days_per_monthly_result) }
  it { is_expected.to validate_numericality_of(:duration_days_per_monthly_result).is_greater_than(0) }
  it { is_expected.to validate_presence_of(:monthly_qualification_amount) }
  it { is_expected.to validate_numericality_of(:monthly_qualification_amount).is_greater_than_or_equal_to(0) }
end
