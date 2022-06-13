require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:order) { build(:order) }

  it 'has a valid factory' do
    expect(order).to be_valid
  end

  it { is_expected.to validate_presence_of(:total) }
  it { is_expected.to validate_numericality_of(:total).is_greater_than_or_equal_to(0) }
  it { is_expected.to validate_presence_of(:subtotal) }
  it { is_expected.to validate_numericality_of(:subtotal).is_greater_than_or_equal_to(0) }
  it { is_expected.to validate_presence_of(:expire_at) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:currency) }
  it { is_expected.to have_one(:payment_transaction) }
  it { is_expected.to have_many(:items) }

  it { is_expected.to have_many(:products).through(:items) }

  it 'has a value equal or greater than' do
    expect(order.subtotal).to be >= 0
  end

  it 'has a value equal or greater than' do
    expect(order.total).to be >= 0
  end
end
