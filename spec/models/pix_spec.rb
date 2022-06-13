require 'rails_helper'

RSpec.describe Pix, type: :model do
  let(:pix) { build(:pix) }

  it 'has a valid factory' do
    expect(pix).to be_valid
  end

  it 'has a default truthy value' do
    expect(pix.active).to be_truthy
  end

  it { is_expected.to validate_presence_of(:secret_key) }
  it { is_expected.to validate_length_of(:secret_key).is_at_most(255) }
  it { is_expected.to validate_presence_of(:kind) }
  it { is_expected.to belong_to(:currency) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to define_enum_for(:kind).with_values %w[detached document cellphone email] }
  it { is_expected.to have_many(:withdraws) }
end
