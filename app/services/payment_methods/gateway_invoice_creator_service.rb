module PaymentMethods
  class GatewayInvoiceCreatorService < ApplicationService
    def call
      return mock_response if Rails.env.test?

      invoice_creator_request
    rescue StandardError => error
      error_message = I18n.t('errors.create_gateway_invoice', error: error.message)

      raise(error_message)
    end

    private

    def initialize(args)
      @amount = args[:amount]
      @current_currency_initials = args[:current_currency_initials].upcase
      @payment_currency_initials = args[:payment_currency_initials].upcase
      @name = args[:name]
      @description = args[:description]
    end

    def mock_response
      rates = Coinbase::DollarExchangeRates.call
      multiple = rates[@payment_currency_initials] / rates[@current_currency_initials]

      {
        transaction_code: SecureRandom.hex,
        amount: @amount * multiple,
        wallet_address: SecureRandom.hex,
        provider_response: { qr_code: "data:image/png;base64, #{SecureRandom.base64}" }
      }.with_indifferent_access
    end

    def invoice_creator_request
      response = HTTParty.post(endpoint, headers: headers, body: params)
      return response.parsed_response.dig('data') if response.success?

      raise(response.parsed_response.dig('message'))
    end

    def endpoint
      Rails.application.credentials[Rails.env.to_sym][:gateway_invoice_creator_url]
    end

    def headers
      authorization_key =
        Rails.application.credentials[Rails.env.to_sym][:gateway_authorization_key]

      headers = { Authorization: authorization_key }
    end

    def params
      {
        name: @name,
        description: @description,
        amount: @amount,
        current_currency: @current_currency_initials,
        payment_currency: @payment_currency_initials
      }
    end
  end
end
