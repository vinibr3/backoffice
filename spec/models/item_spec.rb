require 'rails_helper'

RSpec.describe Item, type: :model do
  let(:item) { build(:item) }

  it 'has a valid factory' do
    expect(item).to be_valid
  end

  it { is_expected.to validate_presence_of(:quantity) }
  it { is_expected.to validate_numericality_of(:quantity).is_greater_than(0) }
  it { is_expected.to validate_presence_of(:unit_price) }
  it { is_expected.to validate_numericality_of(:unit_price).is_greater_than_or_equal_to(0) }
  it { is_expected.to validate_presence_of(:total_price) }
  it { is_expected.to validate_numericality_of(:total_price).is_greater_than_or_equal_to(0) }
  it { is_expected.to belong_to(:product) }
  it { is_expected.to belong_to(:order) }
end
