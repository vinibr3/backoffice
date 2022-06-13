class Api::V1::Users::CurrenciesController < UsersController
	before_action :authenticate!

	def index
		currencies = Currency.active
							           .page(page)
							           .per(per_page)

		render jsonapi: currencies,
		       links: pagination_links(currencies)
	end
end
