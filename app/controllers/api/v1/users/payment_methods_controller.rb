class Api::V1::Users::PaymentMethodsController < UsersController
  before_action :authenticate!

  def index
    payment_methods = PaymentMethod.includes(:currency)
                                   .active
                                   .page(page)
                                   .per(per_page)

    render jsonapi: payment_methods,
           include: %i[currency],
           links: pagination_links(payment_methods)
  end
end
