class WithdrawMailer < ApplicationMailer
  def confirmation
    @withdraw = params[:withdraw]
    @confirmation_url = params[:confirmation_url]

    mail(to: @withdraw.user.email, subject: t('.subject'))
  end
end
