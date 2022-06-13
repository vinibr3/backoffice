require 'rails_helper'

RSpec.describe Category, type: :model do
  let(:category) { build(:category) }

  it 'has a valid factory' do
    expect(category).to be_valid
  end

  it 'has truthy value' do
    expect(Category.new.active).to be_truthy
  end

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  it { is_expected.to validate_length_of(:name).is_at_most(255) }
  it { is_expected.to validate_presence_of(:code) }
  it { is_expected.to validate_uniqueness_of(:code) }
end
