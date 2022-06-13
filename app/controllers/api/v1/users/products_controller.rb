# frozen_string_literal: true

class Api::V1::Users::ProductsController < UsersController
  before_action :authenticate!

  def index
    products = Product.includes(:category, :profile)
                      .active
                      .page(page)
                      .per(per_page)

    render jsonapi: products,
           include: %i[category profile],
           links: pagination_links(products)
  end
end
