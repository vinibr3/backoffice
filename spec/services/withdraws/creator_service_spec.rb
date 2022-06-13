require 'rails_helper'

RSpec.describe Withdraws::CreatorService, type: :service do
  let(:currencies) { Currency::INITIALS.values.map { |i| create(:currency, initials: i) } }
  let(:currency) { currencies.sample }
  let!(:user) { create(:user) }
  let(:gross_amount) { Faker::Number.positive.round(8) }
  let(:receivable_method) { create([:bank_account, :wallet, :pix].sample, currency: currencies.sample) }
  let(:confirmation_url) { Faker::Internet.url }

  subject { Withdraws::CreatorService.call(user: user,
                                           gross_amount: gross_amount,
                                           currency_id: currency.id,
                                           receivable_method_id: receivable_method.id,
                                           receivable_method_type: receivable_method.class.name,
                                           confirmation_url: confirmation_url) }
  it 'creates withdraw for user' do
    expect { subject }.to change { user.withdraws
                                       .where(currency: currency)
                                       .where(receivable_method: receivable_method)
                                       .count }.by(1)
  end

  it 'withdraw has passed gross_amount' do
    expect(subject.gross_amount).to be_within(0.00000001).of(gross_amount)
  end

  it 'withdraw has passed currency' do
    expect(subject.currency).to eq(currency)
  end

  it 'withdraw has passed receivable_method' do
    expect(subject.receivable_method).to eq(receivable_method)
  end

  it 'debits withdraw amount from user balance' do
    expect { subject }.to change { user.financial_transactions
                                       .out
                                       .where(financial_reason: FinancialReason.withdraw,
                                              currency: currency)
                                       .sum(&:user_amount).round(7) }.by(-gross_amount.round(7))
  end

  context 'when gross_amount less than minimum_amount' do
    before { WithdrawParametrization.create(minimum_amount: gross_amount + 1, currency: currency) }

    subject { Withdraws::CreatorService.call(user: user,
                                             gross_amount: gross_amount,
                                             currency_id: currency.id,
                                             receivable_method_id: receivable_method.id,
                                             receivable_method_type: receivable_method.class.name,
                                             confirmation_url: confirmation_url) }

    it 'raise backoffice error' do
      expect { subject }.to raise_error { BackofficeError }
    end
  end

  context 'when gross_amount greater than maximum_amount' do
    before { WithdrawParametrization.create(minimum_amount: 1, maximum_amount: gross_amount - 1, currency: currency) }

    subject { Withdraws::CreatorService.call(user: user,
                                             gross_amount: gross_amount,
                                             currency_id: currency.id,
                                             receivable_method_id: receivable_method.id,
                                             receivable_method_type: receivable_method.class.name,
                                             confirmation_url: confirmation_url) }

    it 'raise backoffice error' do
      expect { subject }.to raise_error { BackofficeError }
    end
  end

  context 'when mandatory withdraw confirmation by email' do
    context 'with confirmation_url blank' do
      before { SystemParametrization.current.update!(mandatory_withdraw_confirmation_by_email: true) }

      subject { Withdraws::CreatorService.call(user: user,
                                               gross_amount: gross_amount,
                                               currency_id: currency.id,
                                               receivable_method_id: receivable_method.id,
                                               receivable_method_type: receivable_method.class.name) }

      it 'raise Invalid Confirmation Url' do
        expect { subject }.to raise_error(BackofficeError, 'Invalid Confirmation Url')
      end
    end
  end
end
