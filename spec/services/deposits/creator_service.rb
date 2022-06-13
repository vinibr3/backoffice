require 'rails_helper'

RSpec.describe Deposits::CreatorService, type: :service do
  let(:user) { create(:user) }
  let(:amount) { Faker::Number.positive }
  let(:currency) { create(:currency) }
  let(:payment_method) { create(:payment_method, :with_valid_code, currency: currency) }

  subject { Deposits::CreatorService.call(user: user, amount: amount, payment_method_id: payment_method.id) }

  it 'creates deposit for user' do
    expect(subject.user).to eq(user)
  end

  it 'assigns deposit amount' do
    expect(subject.amount.round(2)).to eq(amount.round(2))
  end

  it 'assigns payment method of payment_transaction' do
    expect(subject.payment_transaction.payment_method).to eq(payment_method)
  end

  it 'assigns payment_transaction amount in payment currency' do
    rates = Coinbase::DollarExchangeRates.call
    multiple = rates[payment_method.currency.initials.upcase] / rates[Currency.dollar.initials.upcase]
    payment_amount = (amount * multiple).round(8).to_f

    expect(subject.payment_transaction.amount).to be_within(0.00000001).of(payment_amount)
  end
end
