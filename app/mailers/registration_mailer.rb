class RegistrationMailer < ApplicationMailer
  def confirm
    @user = params[:user]
    @registration_confirmation_url = params[:registration_confirmation_url]

    mail(to: @user.email, subject: t('.subject')) if @user.email.present?
  end

  def new
    @user = params[:user]
    subject = t('.subject', company_name: Rails.application.credentials.company_name)

    mail(to: @user.email, subject: subject) if @user.email.present?
  end
end
