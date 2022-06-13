require 'rails_helper'

RSpec.describe FinancialTransactions::IndirectIndicationCreatorService, type: :service do
  let(:financial_reason) { create(:indirect_indication, active: true) }
  let(:order) { create(:order_with_items, user: User.last) }
  let(:percentage) { Faker::Number.between(from: 1, to: 100) }
  let(:percentages_per_generation) { { '2': Faker::Number.between(from: 1, to: 100),
                                       '3': Faker::Number.between(from: 1, to: 100),
                                       '4': Faker::Number.between(from: 1, to: 100),
                                       '5': Faker::Number.between(from: 1, to: 100) }.with_indifferent_access }
  let(:amounts) {
    order.items.map do |i|
      percentages_per_generation.map do |generation, percentage|
        commission = financial_reason.bonus_commissions
                                     .find_by(generation: generation, product: i.product)
        (i.total_price * commission.percentage / 100.0).round(2)
      end
    end
  }

  before do
    UnilevelNodeTree.create
    SystemParametrization.current.update!(pay_indirect_indication_bonus: true)
    order.products.each do |p|
      percentages_per_generation.each do |generation, percentage|
        p.bonus_commissions.create(financial_reason: financial_reason,
                                   percentage: percentage,
                                   generation: generation)
      end
    end
  end

  subject { FinancialTransactions::IndirectIndicationCreatorService.call(order: order) }

  context 'when financial_reason inactive' do
    before { financial_reason.update!(active: false) }

    it 'do not creates transaction' do
      expect { subject }.to change { FinancialTransaction.count }.by(0)
    end
  end

  context 'when system no pay direct indication bonus' do
    before { SystemParametrization.current.update!(pay_indirect_indication_bonus: false) }

    it 'do not creates transaction' do
      expect { subject }.to change { FinancialTransaction.count }.by(0)
    end
  end

  context 'when users inactive' do
    before { User.update_all(active_until_at: [2.days.ago, nil].sample) }

    it 'chargebacks by inactivity' do
      chargeback_by_inactivity = subject.flatten.map {|f| f.chargeback_by_inactivity }

      expect(chargeback_by_inactivity).to all be_present
    end
  end

  context 'when users active' do
    before { User.update_all(active_until_at: 5.days.from_now) }

    it 'creates direct indication bonus per item for sponsors' do
      transactions_count = order.items.count * percentages_per_generation.size

      expect { subject }.to change { FinancialTransaction.count }.by(transactions_count)
    end

    it 'bonus amount is percentage about order item' do
      bonus_amounts = subject.flatten.map { |b| b.user_amount.round(2) }

      expect(bonus_amounts.flatten).to eq(amounts.flatten)
    end
  end
end
