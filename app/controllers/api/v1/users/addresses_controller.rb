class Api::V1::Users::AddressesController < UsersController
  before_action :authenticate!

  def create
    current_user.create_address!(address_params)

    render jsonapi: current_user.address
  end

  def update
    if current_user.address
      current_user.address.update!(address_params)
    else
      current_user.create_address!(address_params)
    end

    render jsonapi: current_user.address
  end

  private

  def address_params
    params.require(:data)
          .permit(attributes: [:zipcode, :street, :number, :complement,
                               :district, :city, :state, :country, :proove])
  end
end
