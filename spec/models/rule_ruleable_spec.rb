require 'rails_helper'

RSpec.describe RuleRuleable, type: :model do
  let(:rule_ruleable) { build(:rule_ruleable) }

  it 'has a valid factory' do
    expect(rule_ruleable).to be_valid
  end

  describe 'when create rule_ruleable' do
    context 'inactivator_id present' do
      before { allow(subject).to receive(:inactivator?).and_return(true) }
      it { is_expected.to validate_presence_of(:inactive_at) }
    end

    context 'inactivator_id absent' do
      before { allow(subject).to receive(:inactivator?).and_return(false) }
      it { is_expected.not_to validate_presence_of(:inactive_at) }
    end
  end
  it { is_expected.to belong_to(:rule) }
  it { is_expected.to belong_to(:ruleable) }
end
