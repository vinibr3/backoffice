require "rails_helper"

RSpec.describe WithdrawMailer, type: :mailer do
  describe 'confirmation' do
    let(:withdraw) { create(:withdraw) }
    let(:confirmation_url) { Faker::Internet.url }
    let(:mail) { WithdrawMailer.with(withdraw: withdraw, confirmation_url: confirmation_url)
                               .confirmation }

    it 'renders subject' do
      expect(mail.subject).to eq('Withdraw Confirmation')
    end

    it 'renders to' do
      expect(mail.to).to eq([withdraw.user.email])
    end

    it 'renders the title' do
      expect(mail.body.encoded).to match('Click on the link below to confirm your withdraw.')
    end

    it 'renders confirmation url' do
      expect(mail.body.encoded).to match(confirmation_url)
    end
  end
end
