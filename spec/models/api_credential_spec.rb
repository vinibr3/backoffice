require 'rails_helper'

RSpec.describe ApiCredential, type: :model do
  let(:api_credential) { create(:api_credential) }

  it 'has a valid factory' do
    expect(api_credential).to be_valid
  end

  it { is_expected.to(validate_presence_of(:key)) }
  it { is_expected.to(validate_presence_of(:secret)) }
  it { is_expected.to(belong_to(:user)) }
end
