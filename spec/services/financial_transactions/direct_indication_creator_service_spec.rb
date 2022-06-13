require 'rails_helper'

RSpec.describe FinancialTransactions::DirectIndicationCreatorService, type: :service do
  let(:financial_reason) { create(:financial_reason,
                                  code: FinancialReason::CODES[:direct_indication],
                                  active: true) }
  let(:unilevel_node) { create(:unilevel_node) }
  let(:order) { create(:order_with_items, user: unilevel_node.sponsored) }
  let(:percentage) { Faker::Number.between(from: 1, to: 100) }
  let(:amounts) {
    order.items.map do |i|
      commission = financial_reason.bonus_commissions
                                   .find_by(generation: 1, product: i.product)
      (i.total_price * commission.percentage / 100.0).round(2)
    end
  }

  before do
    SystemParametrization.current.update!(pay_direct_indication_bonus: true)
    order.products.each { |p| p.bonus_commissions.create(financial_reason: financial_reason,
                                                         percentage: percentage,
                                                         generation: 1) }
  end

  subject { FinancialTransactions::DirectIndicationCreatorService.call(order: order) }

  context 'when financial_reason inactive' do
    before { financial_reason.update!(active: false) }

    it 'do not creates transaction' do
      expect { subject }.to change { FinancialTransaction.count }.by(0)
    end
  end

  context 'when system no pay direct indication bonus' do
    before { SystemParametrization.current.update!(pay_direct_indication_bonus: false) }

    it 'do not creates transaction' do
      expect { subject }.to change { FinancialTransaction.count }.by(0)
    end
  end

  context 'when users inactive' do
    before { User.update_all(active_until_at: [2.days.ago, nil].sample) }

    it 'chargebacks by inactivity' do
      chargeback_by_inactivity = subject.map {|f| f.chargeback_by_inactivity }

      expect(chargeback_by_inactivity).to all be_present
    end
  end

  context 'when users active' do
    before { User.update_all(active_until_at: 5.day.from_now) }

    it 'creates direct indication bonus per item for sponsor' do
      expect { subject }.to change { order.user.sponsor.financial_transactions.count }.by(order.items.count)
    end

    it 'bonus amount is percentage about order item' do
      bonus_amounts = subject.map { |b| b.user_amount.round(2) }

      expect(bonus_amounts).to eq(amounts)
    end
  end
end
