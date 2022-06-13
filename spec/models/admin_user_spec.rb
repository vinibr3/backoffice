require 'rails_helper'

RSpec.describe AdminUser, type: :model do
  let(:admin_user) { build(:admin_user) }

  it 'has a valid factory' do
    expect(admin_user).to be_valid
  end

  describe 'when email present' do
    context 'with valid email' do
      let(:admin_user) { build(:admin_user, email: Faker::Internet.email) }

      it 'admin_user is valid' do
        expect(admin_user).to be_valid
      end

      it 'email match email regexp' do
        expect(admin_user.email).to match(URI::MailTo::EMAIL_REGEXP)
      end
    end

    context 'with invalid email' do
      let(:admin_user) { build(:admin_user, email: 'asf') }

      it 'admin_user is invalid' do
        expect(admin_user).to be_invalid
      end

      it 'email to not match email regexp' do
        expect(admin_user.email).to_not match(URI::MailTo::EMAIL_REGEXP)
      end
    end
  end

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email) }
  it { is_expected.to validate_length_of(:email).is_at_most(255) }
  it { is_expected.to validate_length_of(:name).is_at_most(255) }
  it { is_expected.to validate_length_of(:phone).is_at_most(255) }
  it { is_expected.to validate_length_of(:document).is_at_most(255) }
  it { is_expected.to define_enum_for(:gender).with_values({male: 0, female: 1}) }
  it { is_expected.to have_one(:compliance_user).with_foreign_key(:compliance_admin_user_id) }
end
