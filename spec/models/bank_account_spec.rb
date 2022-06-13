require 'rails_helper'

RSpec.describe BankAccount, type: :model do
  let(:bank_account) { build(:bank_account) }

  it 'has a valid factory' do
    expect(bank_account).to be_valid
  end

  it 'has a deafault truthy value' do
    expect(bank_account.active).to be_truthy
  end

  it { is_expected.to validate_presence_of(:bank_name) }
  it { is_expected.to validate_length_of(:bank_name).is_at_most(255) }
  it { is_expected.to validate_presence_of(:kind) }
  it { is_expected.to define_enum_for(:kind).with_values %w[checking savings] }
  it { is_expected.to validate_presence_of(:agency) }
  it { is_expected.to validate_length_of(:agency).is_at_most(255) }
  it { is_expected.to validate_presence_of(:number) }
  it { is_expected.to validate_length_of(:number).is_at_most(255) }
  it { is_expected.to validate_presence_of(:digit) }
  it { is_expected.to validate_length_of(:digit).is_at_most(255) }
  it { is_expected.to belong_to(:currency) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:withdraws) }
end
