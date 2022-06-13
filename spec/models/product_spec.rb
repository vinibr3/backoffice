require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:product) { build(:product) }

  it "has a valid factory" do
    expect(product).to be_valid
  end

  it "has default truthy value" do
    expect(product.active).to be_truthy
  end

  it { is_expected.to validate_presence_of(:price) }
  it { is_expected.to validate_numericality_of(:price) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_most(255) }
  it { is_expected.to validate_presence_of(:code) }
  it { is_expected.to validate_uniqueness_of(:code) }
  it { is_expected.to belong_to(:category) }
  it { is_expected.to have_many(:bonus_commissions) }
end
