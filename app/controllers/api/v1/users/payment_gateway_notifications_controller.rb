class Api::V1::Users::PaymentGatewayNotificationsController < ApplicationController
  before_action :authenticate_payment_gateway_key!

  def create
    PaymentTransactions::PayerService.call(notification: notification)
  end

  private

  def notification
    params.require(:payment_block_notification)
  end
end
