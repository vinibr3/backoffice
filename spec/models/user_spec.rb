require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  it 'has a valid factory' do
    expect(user).to be_valid
  end

  describe 'when email present' do
    context 'with valid email' do
      let(:user) { build(:user, email: Faker::Internet.email) }

      it 'user is valid' do
        expect(user).to be_valid
      end

      it 'email match email regexp' do
        expect(user.email).to match(URI::MailTo::EMAIL_REGEXP)
      end
    end

    context 'with invalid email' do
      let(:user) { build(:user, email: 'asf') }

      it 'user is invalid' do
        expect(user).to be_invalid
      end

      it 'email to not match email regexp' do
        expect(user.email).to_not match(URI::MailTo::EMAIL_REGEXP)
      end
    end
  end

  describe 'when terms of service accepted' do
    context 'with terms_of_service_accepted_at and terms_of_service_accepted_ip' do
      let(:user) { build(:user, :with_terms_of_service_accepted) }

      it 'user is valid' do
        expect(user).to be_valid
      end

      it 'terms_of_service_accepted_at be present' do
        expect(user.terms_of_service_accepted_at).to be_present
      end

      it 'terms_of_service_accepted_ip be present' do
        expect(user.terms_of_service_accepted_ip).to be_present
      end
    end

    context 'without terms_of_service_accepted_at and terms_of_service_accepted_ip' do
      let(:user) { build(:user, :without_terms_of_service_accepted) }

      it 'user is invalid' do
        expect(user).to be_invalid
      end

      it 'terms_of_service_accepted_at to not be present' do
        expect(user.terms_of_service_accepted_at).to_not be_present
      end

      it 'terms_of_service_accepted_ip to not be present' do
        expect(user.terms_of_service_accepted_ip).to_not be_present
      end
    end
  end

  describe 'when reset_password_token be present' do
    context 'with reset_password_token_sent_at' do
      let(:user) { build(:user, reset_password_token: SecureRandom.hex, reset_password_token_sent_at: Time.now) }

      it 'user be valid' do
        expect(user).to be_valid
      end
    end

    context 'without reset_password_token_sent_at' do
      let(:user) { build(:user, reset_password_token: SecureRandom.hex, reset_password_token_sent_at: nil) }

      it 'user be invalid' do
        expect(user).to be_invalid
      end
    end
  end

  describe 'when confirmation_token be present' do
    context 'with confirmation_sent_at' do
      let(:user) { build(:user, confirmation_token: SecureRandom.hex, confirmation_token_sent_at: Time.now) }

      it 'user be valid' do
        expect(user).to be_valid
      end
    end

    context 'without confirmation_token_send_at' do
      let(:user) { build(:user, confirmation_token: SecureRandom.hex, confirmation_token_sent_at: nil) }

      it 'user be invalid' do
        expect(user).to be_invalid
      end
    end
  end

  describe 'when validate presence of registration attribute' do
    before { create(:system_parametrization) }

    let(:registration_attribute) { SystemParametrization.current.registration_attribute.to_sym }

    context 'with current registration attribute' do
      let(:attribute) { attributes_for(:user).slice(registration_attribute) }
      let(:user) { build(:user, attribute) }

      it 'user is valid' do
        expect(user).to be_valid
      end
    end

    context 'without current registration attribute' do
      let(:user) { build(:user, Hash[registration_attribute, '']) }

      it 'user is invalid' do
        expect(user).to be_invalid
      end
    end
  end

  describe 'when validate presence of sponsor token' do
    context 'with sponsor token blank' do
      let(:user) { create(:user, sponsor_token: '') }

      it 'assign sponsor token' do
        expect(user.sponsor_token).to be_present
      end

      it 'user is valid' do
        expect(user).to be_valid
      end
    end
  end

  context 'when create User.new validates uniqueness of' do
    before { create(:user) }

    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to validate_uniqueness_of(:document).case_insensitive }
    it { is_expected.to validate_uniqueness_of(:cellphone).case_insensitive }
    it { is_expected.to validate_uniqueness_of(:nickname).case_insensitive }
  end

  it { is_expected.to(have_secure_password) }
  it { is_expected.to(have_db_index(:nickname)) }
  it { is_expected.to(define_enum_for(:gender).with_values({male: 0, female: 1})) }
  it { is_expected.to(have_db_index(:document)) }
  it { is_expected.to(have_db_index(:cellphone)) }
  it { is_expected.to(have_db_index(:sponsor_token)) }
  it { is_expected.to(validate_presence_of(:provider)) }
  it { is_expected.to(have_db_index(:uid)) }
  it { is_expected.to(have_db_index(:reset_password_token)) }
  it { is_expected.to(have_db_index(:confirmation_token)) }
  it { is_expected.to(validate_length_of(:email).is_at_most(255)) }
  it { is_expected.to(validate_length_of(:password).is_at_most(255)) }
  it { is_expected.to(validate_length_of(:name).is_at_most(255)) }
  it { is_expected.to(validate_length_of(:nickname).is_at_most(255)) }
  it { is_expected.to(validate_length_of(:document).is_at_most(255)) }
  it { is_expected.to(validate_length_of(:cellphone).is_at_most(255)) }
  it { is_expected.to(validate_length_of(:facebook).is_at_most(255)) }
  it { is_expected.to(validate_length_of(:instagram).is_at_most(255)) }
  it { is_expected.to(validate_length_of(:twitter).is_at_most(255)) }
  it { is_expected.to(validate_length_of(:sponsor_token).is_at_most(255)) }
  it { is_expected.to(validate_length_of(:provider).is_at_most(255)) }
  it { is_expected.to(validate_length_of(:uid).is_at_most(255)) }
  it { is_expected.to(validate_length_of(:reset_password_token).is_at_most(255)) }
  it { is_expected.to(validate_length_of(:confirmation_token).is_at_most(255)) }
  it { is_expected.to(validate_length_of(:password).is_at_most(255)) }
  it { is_expected.to(have_many(:unilevel_nodes)) }
  it { is_expected.to(have_many(:sponsoreds).through(:unilevel_nodes).class_name('User')) }
  it { is_expected.to(have_many(:orders)) }
  it { is_expected.to(have_many(:user_profiles)) }
  it { is_expected.to(have_many(:financial_transactions)) }
  it { is_expected.to have_one(:address) }
  it { is_expected.to(have_one(:unilevel_node).with_foreign_key(:sponsored_id)) }
  it { is_expected.to(have_one(:sponsor).through(:unilevel_node).with_foreign_key(:sponsored_id)) }
  it { is_expected.to belong_to(:admin_user).with_foreign_key(:compliance_admin_user_id).optional }
  it { is_expected.to belong_to(:profile).optional }
  it { is_expected.to have_many(:deposits) }
  it { is_expected.to have_many(:api_credentials) }
  it { is_expected.to have_many(:withdraws) }
  it { is_expected.to have_many(:wallets) }
  it { is_expected.to have_many(:pixes) }
  it { is_expected.to have_many(:bank_accounts) }
end
