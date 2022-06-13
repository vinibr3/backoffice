# frozen_string_literal: true

class Withdraws::CreatorService < ApplicationService
  def call
    ActiveRecord::Base.transaction do
      validates_gross_amount

      withdraw = creates_withdraw
      debits_withdraw_amount_from_user_balance(withdraw)
      if SystemParametrization.current.mandatory_withdraw_confirmation_by_email
        validates_confirmation_url
        validates_user_email
        withdraw.update!(confirmation_token: SecureRandom.hex, status: :confirmation)
        send_confirmation_email_to_user(withdraw)
      end

      withdraw
    end
  end

  private

  def initialize(args)
    @user = args[:user]
    @currency = Currency.find(args[:currency_id])
    @receivable_method_id = args[:receivable_method_id]
    @receivable_method_type = args[:receivable_method_type]
    @receivable_method = args[:receivable_method_type].camelize.safe_constantize.find(@receivable_method_id)
    @gross_amount = args[:gross_amount].to_f
    @confirmation_url = args[:confirmation_url].to_s
  end

  def validates_gross_amount
    return if WithdrawParametrization.valid?(@currency, @gross_amount)

    raise BackofficeError.new(message: 'Invalid Gross Amount', pointer: '/data/attributes/gross_amount')
  end

  def creates_withdraw
    @user.withdraws.create!(currency: @currency,
                            receivable_method_type: @receivable_method_type,
                            receivable_method_id: @receivable_method_id,
                            gross_amount: @gross_amount,
                            net_amount: 0,
                            fee: 0,
                            receivable_currency_amount: receivable_currency_amount,
                            status: :created,
                            status_update_at: Time.zone.now)
  end

  def receivable_currency_amount
    rates = Coinbase::DollarExchangeRates.call
    multiple = rates[@receivable_method.currency.initials.upcase] / rates[@currency.initials.upcase]

    (@gross_amount * multiple).round(8)
  end

  def debits_withdraw_amount_from_user_balance(withdraw)
    withdraw.user.financial_transactions
                 .create!(financial_reason: FinancialReason.withdraw,
                          currency: withdraw.currency,
                          note: '',
                          user_amount: -withdraw.gross_amount,
                          user_cashflow: :out,
                          admin_amount: 0,
                          admin_cashflow: :not_applicable,
                          system_amount: 0,
                          system_cashflow: :not_applicable,
                          withdraw: withdraw)
  end

  def validates_confirmation_url
    return if @confirmation_url.match?(URL_REGEXP)

    message = 'Invalid Confirmation Url'
    pointer = '/data/attributes/confirmation_url'

    raise BackofficeError.new(message: message, pointer: pointer)
  end

  def validates_user_email
    return if @user.email.to_s.match?(EMAIL_REGEXP)

    raise BackofficeError.new(message: 'Invalid User Email', parameter: 'user email')
  end

  def send_confirmation_email_to_user(withdraw)
    WithdrawMailer.with(withdraw: withdraw, confirmation_url: @confirmation_url)
                  .confirmation
                  .deliver_later
  end
end
