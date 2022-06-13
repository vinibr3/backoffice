class Api::V1::Users::OrdersController < UsersController
  before_action :authenticate!

  def create
    order = Users::Orders::CreatorService.call(valid_params)

    render jsonapi: order,
           include: [:user, :currency, items: [:product], payment_transaction: [payment_method: :currency]]
  end

  def show
    order = Order.find(params[:id])

    render jsonapi: order,
           include: [:user, :currency, items: [:product], payment_transaction: [payment_method: :currency]]
  end

  private

  def valid_params
    attributes = [:payment_method_id, items: [:quantity, :product_id]]

    params.require(:data)
          .permit(attributes: attributes)[:attributes]
          .merge(user: current_user)
  end
end
