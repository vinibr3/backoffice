class Api::V1::Users::UsersController < UsersController
  before_action :authenticate!

  def update
    current_user.update!(user_params)
    current_user.document_proove.attach(params[:document_proove])

    render_user(current_user)
  end

  private

  def user_params
    params.require(:data)
          .permit(attributes: [:name, :email, :document, :birthdate, :gender,
                               :cellphone, :facebook, :instagram, :twitter, :nickname, :document_proove])
  end
end
