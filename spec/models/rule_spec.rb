require 'rails_helper'

RSpec.describe Rule, type: :model do
  let(:rule) { build(:rule) }

  it 'has a valid factory' do
    expect(rule).to be_valid
  end

  it { is_expected.to validate_presence_of(:code) }
  it { is_expected.to validate_uniqueness_of(:code) }
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_most(255) }
end
