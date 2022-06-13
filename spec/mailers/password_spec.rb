require 'rails_helper'

RSpec.describe PasswordMailer, type: :mailer do
  describe 'new' do
    let(:user) { build(:user) }
    let(:reset_password_url) { Faker::Internet.url }
    let(:mail) { PasswordMailer.with(user: user, reset_password_url: reset_password_url).new }

    it 'validates subject' do
      expect(mail.subject).to eq('Password Reset')
    end

    it 'validates destination mail' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders title' do
      expect(mail.body.encoded).to match('Click on the link below to reset your password')
    end

    it 'renders password reset link' do
      expect(mail.body.encoded).to match(reset_password_url)
    end
  end
end
