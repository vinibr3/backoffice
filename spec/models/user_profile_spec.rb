require 'rails_helper'

RSpec.describe UserProfile, type: :model do
  let(:user_profile) { build(:user_profile) }

  it 'has a valid factory' do
    expect(user_profile).to be_valid
  end

  it { is_expected.to validate_presence_of(:expire_at) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:profile) }
end
