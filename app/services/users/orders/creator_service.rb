class Users::Orders::CreatorService < ApplicationService
  def call
    ActiveRecord::Base.transaction do
      order = create_order

      payment_response = payment_request(order)
      payment_transaction(payment_response, order)

      order
    end
  end

  private

  def initialize(args)
    @user = args[:user]

    @payment_method = PaymentMethod.find(args[:payment_method_id])
    @items = args[:items]
    @products = Product.where(id: @items.map {|i| i[:product_id] })
                       .index_by(&:id)
                       .stringify_keys
  end

  def create_order
    items = @items.map do |item|
              product = @products[item[:product_id].to_s]
              quantity = item[:quantity].to_i

              Item.new(product: product,
                       quantity: quantity,
                       unit_price: product.price,
                       total_price: product.price * quantity)
            end

    @user.orders.create!(items: items,
                         subtotal: items.sum(&:total_price),
                         total: items.sum(&:total_price),
                         expire_at: 1.days.from_now,
                         currency: Currency.dollar)
  end

  def payment_request(order)
    {
     PaymentMethod::VALID_CODES[:btc_plisio] =>
        -> { PaymentMethods::GatewayInvoiceCreatorService.call(gateway_params(order)) },
     PaymentMethod::VALID_CODES[:eth_plisio] =>
        -> { PaymentMethods::GatewayInvoiceCreatorService.call(gateway_params(order)) }
    }[@payment_method.code].call
  end

  def gateway_params(order)
    names = SystemParametrization.current.sign_in_attributes.map {|a| @user.read_attribute(a.to_sym) }

    {
      amount: order.total,
      current_currency_initials: order.currency.initials.upcase,
      payment_currency_initials: @payment_method.currency.initials.upcase,
      name: names.detect(&:present?),
      description: order.id
    }
  end

  def payment_transaction(payment_response, order)
    attributes = {
                  status: :unpaid,
                  transaction_code: payment_response.dig('transaction_code'),
                  amount: payment_response.dig('amount'),
                  creation_response: payment_response,
                  digital_address: payment_response.dig('wallet_address'),
                  qr_code_base64: payment_response.dig('provider_response', 'qr_code'),
                  payment_method: @payment_method
                }

    order.create_payment_transaction!(attributes)
  end
end
