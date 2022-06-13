module Coinbase
  class DollarExchangeRates < ApplicationService
    def call
      response = exchange_rates_request
      response.dig('data', 'rates').transform_values(&:to_d)
                                   .with_indifferent_access
    rescue StandardError => error
      error_message = I18n.t('defaults.errors.coinbase_rates', error: error_message)

      raise(error_message)
    end

    def exchange_rates_request
      response = HTTParty.get('https://api.coinbase.com/v2/exchange-rates')
      return response.parsed_response if response.success?

      raise(response.code.to_s)
    end
  end
end
