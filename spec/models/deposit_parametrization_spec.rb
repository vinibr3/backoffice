require 'rails_helper'

RSpec.describe DepositParametrization, type: :model do
  let(:deposit_parametrization) { build(:deposit_parametrization) }
  let(:amount) { Faker::Number.number(digits: 10) }

  it 'has a valid factory' do
    expect(deposit_parametrization).to be_valid
  end

  context 'when assign minimum_amount' do
    let(:deposit_parametrization) { build(:deposit_parametrization, minimum_amount: amount) }

    it 'saves as multiple of 1e8' do
      expect(deposit_parametrization[:minimum_amount]).to eq((amount.to_f * 1e8).to_i)
    end

    it 'return as decimal of 1e8' do
      expect(deposit_parametrization.minimum_amount).to eq(amount)
    end
  end

  context 'when assign maximum_amount' do
    let(:deposit_parametrization) { build(:deposit_parametrization, maximum_amount: amount) }

    it 'saves as multiple of 1e8' do
      expect(deposit_parametrization[:maximum_amount]).to eq((amount.to_f * 1e8).to_i)
    end

    it 'return as decimal of 1e8' do
      expect(deposit_parametrization.maximum_amount).to eq(amount)
    end
  end

  describe 'when validates maximum_amount > minimum_amount' do
    context 'with maximum_amount > minimum_amount' do
      let(:amount) { Faker::Number.number(digits: 5) }
      let(:positive_amount) { (amount + Faker::Number.number(digits: 5)) }
      let(:withdraw_parametrization) { build(:withdraw_parametrization, maximum_amount: positive_amount, minimum_amount: amount) }

      it 'withdraw_parametrization be valid' do
        expect(withdraw_parametrization).to be_valid
      end
    end

    context 'with maximum_amount = minimum_amount' do
      let(:amount) { Faker::Number.number(digits: 5) }
      let(:withdraw_parametrization) { build(:withdraw_parametrization, maximum_amount: amount, minimum_amount: amount) }

      it 'withdraw_parametrization be invalid' do
        expect(withdraw_parametrization).to be_invalid
      end
    end

    context 'with maximum_amount < minimum_amount' do
      let(:amount) { Faker::Number.number(digits: 5) }
      let(:negative_amount) { (amount - Faker::Number.number(digits: 5)) }
      let(:withdraw_parametrization) { build(:withdraw_parametrization, maximum_amount: negative_amount, minimum_amount: amount) }

      it 'withdraw_parametrization be invalid' do
        expect(withdraw_parametrization).to be_invalid
      end
    end
  end

  it { is_expected.to belong_to(:currency) }
  it { is_expected.to validate_numericality_of(:minimum_amount).is_greater_than(0) }
  it { is_expected.to validate_numericality_of(:maximum_amount).is_greater_than(0) }
end
