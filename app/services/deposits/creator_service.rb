class Deposits::CreatorService < ApplicationService
  def call
    ActiveRecord::Base.transaction do
      deposit = create_deposit

      payment_response = payment_request(deposit)
      payment_transaction(payment_response, deposit)

      deposit
    end
  end

  private

  def initialize(args)
    @user = args[:user]
    @payment_method = PaymentMethod.find(args[:payment_method_id])
    @currency = Currency.find(args[:currency_id])
    @amount = args[:amount].to_f
  end

  def create_deposit
    @user.deposits.create!(amount: @amount,
                           currency: @currency)
  end

  def payment_request(deposit)
    {
     PaymentMethod::VALID_CODES[:btc_plisio] =>
        -> { PaymentMethods::GatewayInvoiceCreatorService.call(gateway_params(deposit)) },
     PaymentMethod::VALID_CODES[:eth_plisio] =>
        -> { PaymentMethods::GatewayInvoiceCreatorService.call(gateway_params(deposit)) }
    }[@payment_method.code].call
  end

  def gateway_params(deposit)
    names = SystemParametrization.current.sign_in_attributes.map {|a| @user.read_attribute(a.to_sym) }

    {
      amount: deposit.amount,
      current_currency_initials: deposit.currency.initials.upcase,
      payment_currency_initials: @payment_method.currency.initials.upcase,
      name: names.detect(&:present?),
      description: 'Deposit' + deposit.id.to_s
    }
  end

  def payment_transaction(payment_response, deposit)
    attributes = {
                  status: :unpaid,
                  transaction_code: payment_response.dig('transaction_code'),
                  amount: payment_response.dig('amount'),
                  creation_response: payment_response,
                  digital_address: payment_response.dig('wallet_address'),
                  qr_code_base64: payment_response.dig('provider_response', 'qr_code'),
                  payment_method: @payment_method
                }

    deposit.create_payment_transaction!(attributes)
  end
end
