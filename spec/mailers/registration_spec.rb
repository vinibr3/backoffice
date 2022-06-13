require 'rails_helper'

RSpec.describe RegistrationMailer, type: :mailer do
  describe 'confirm' do
    let(:user) { create(:user) }
    let(:url) { Faker::Internet.url }
    let(:mail) { RegistrationMailer.with(user: user, registration_confirmation_url: url).confirm }

    it 'subject' do
      expect(mail.subject).to eq('Register Confirmation')
    end

    it 'sends to user email' do
      expect(mail.to).to eq([user.email])
    end

    it 'title' do
      expect(mail.body.encoded).to match('Click on the link below to confirm your register.')
    end

    it 'renders confirmation token on body' do
      expect(mail.body.encoded).to match(user.confirmation_token)
    end
  end

  describe 'new' do
    let(:user) { create(:user, sponsor_token: SecureRandom.hex) }
    let(:mail) { RegistrationMailer.with(user: user).new }

    it 'subject' do
      subject = I18n.t('registration_mailer.new.subject', company_name: Rails.application.credentials.company_name)

      expect(mail.subject).to eq(subject)
    end

    it 'sends to user email' do
      expect(mail.to).to eq([user.email])
    end

    it 'title' do
      expect(mail.body.encoded).to match("It is awesome have you here.")
    end

    it 'renders sponsor token on body' do
      sponsor_token_message =
        I18n.t('registration_mailer.new.sponsor_token', sponsor_token: user.sponsor_token)

      expect(mail.body.encoded).to match(sponsor_token_message)
    end
  end
end
