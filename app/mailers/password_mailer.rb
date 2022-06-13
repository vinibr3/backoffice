# frozen_literal_string: true

class PasswordMailer < ApplicationMailer
  def new
    @user = params[:user]
    @reset_password_url = params[:reset_password_url]

    mail to: @user.email, subject: t('.subject')
  end
end
