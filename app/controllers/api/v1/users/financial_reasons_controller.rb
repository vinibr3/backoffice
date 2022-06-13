class Api::V1::Users::FinancialReasonsController < UsersController
	before_action :authenticate!

	def index
		financial_reasons = FinancialReason.active
							                         .page(page)
							                         .per(per_page)

		render jsonapi: financial_reasons,
		       links: pagination_links(financial_reasons)
	end
end
