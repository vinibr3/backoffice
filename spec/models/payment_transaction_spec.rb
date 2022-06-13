require 'rails_helper'

RSpec.describe PaymentTransaction, type: :model do
  let(:payment_transaction) { build(:payment_transaction) }

  it 'has a valid factory' do
    expect(payment_transaction).to be_valid
  end

  context 'when status of transaction is paid' do
    before { allow(subject).to receive(:paid?).and_return(true) }
    it { should validate_presence_of(:creation_response) }
    it { should validate_presence_of(:notification_response) }
  end

  context 'when status of transaction is NOT paid' do
    before { allow(subject).to receive(:paid?).and_return(false) }
    it { should_not validate_presence_of(:creation_response) }
    it { should_not validate_presence_of(:notification_response) }
  end

  it { is_expected.to validate_presence_of(:transaction_code) }
  it { is_expected.to validate_uniqueness_of(:transaction_code) }
  it { is_expected.to validate_length_of(:transaction_code).is_at_most(255) }
  it { is_expected.to have_db_index(:transaction_code) }
  it { is_expected.to validate_presence_of(:amount) }
  it { is_expected.to validate_numericality_of(:amount).is_greater_than(0) }
  it { is_expected.to belong_to(:payment_method) }
end
