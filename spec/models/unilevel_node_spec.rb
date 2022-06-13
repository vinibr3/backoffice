require 'rails_helper'

RSpec.describe UnilevelNode, type: :model do
  let(:unilevel_node) { build(:unilevel_node) }

  it 'has a valid factory' do
    expect(unilevel_node).to be_valid
  end

  it { is_expected.to(belong_to(:user)) }
  it { is_expected.to(belong_to(:sponsored).class_name('User')) }
end
