require 'rails_helper'

RSpec.describe PaymentTransactions::PayerService, type: :service do
  context 'when transaction is paid' do
    let(:payment_transaction) { build(:payment_transaction, status: :paid) }
    let(:order) { create(:order, payment_transaction: payment_transaction) }
    let(:notification) { { transaction_code: order.payment_transaction.transaction_code } }

    subject { PaymentTransactions::PayerService.call(notification: notification) }

    it 'raise record not found' do
      expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context 'when transaction is unpaid' do
    let(:payment_transaction) { build(:payment_transaction, :with_status_unpaid) }
    let(:order) { create(:order, payment_transaction: payment_transaction) }
    let(:notification) { { transaction_code: order.payment_transaction.transaction_code } }

    subject { PaymentTransactions::PayerService.call(notification: notification) }

    it 'assign payment date' do
      expect(subject.paid_at).to be_present
    end

    it 'assign status as paid' do
      expect(subject).to be_paid
    end

    it 'assign notification response' do
      expect(subject.notification_response).to be_present
    end

    it 'increments company balance' do
      expect { subject }.to change {
        FinancialTransaction.where(currency: order.currency,
                                   spreader_user: order.user,
                                   financial_reason: FinancialReason.order_payment,
                                   admin_cashflow: :in).sum(&:admin_amount)
                                  }.by(order.total)
    end

    describe 'with order having product with profile' do
      let(:item) { build(:item, product: build(:product, profile: build(:profile))) }
      let(:order) { build(:order, items: [item]) }
      let(:payment_transaction) { create(:payment_transaction, :with_status_unpaid, payable: order) }
      let(:notification) { { transaction_code: payment_transaction.transaction_code } }
      let(:profile) { payment_transaction.payable.products.detect(&:profile) }
      let(:user) { payment_transaction.payable.user }

      before do
        user.update(profile: nil)
        user.user_profiles.destroy_all
      end

      subject { PaymentTransactions::PayerService.call(notification: notification) }

      it 'add profile to user' do
        expect(subject.payable.user.profile).to be_present
      end

      it 'creates user profile' do
        expect { subject }.to change { user.user_profiles.count }.by(1)
      end

      it 'create user profile with expiring date' do
        expect(subject.payable.user.user_profiles.last.expire_at).to be_present
      end
    end

    context 'when payable is deposit' do
      let(:deposit) { create(:deposit, payment_transaction: create(:payment_transaction, :with_status_unpaid)) }
      let(:notification) { { transaction_code: deposit.payment_transaction.transaction_code } }

      subject { PaymentTransactions::PayerService.call(notification: notification) }

      it 'adds deposit amount to user_balance' do
        expect { subject }.to change { deposit.user
                                              .financial_transactions
                                              .where(currency: deposit.currency)
                                              .sum(&:user_amount) }.by(deposit.amount)
      end
    end
  end
end
