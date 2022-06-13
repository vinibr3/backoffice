class FinancialTransaction < ApplicationRecord
  CASHFLOWS = { not_applicable: 0, in: 1, out: 2 }.freeze

  enum admin_cashflow: CASHFLOWS, _prefix: true
  enum system_cashflow: CASHFLOWS, _prefix: true
  enum user_cashflow: CASHFLOWS

  belongs_to :user
  belongs_to :spreader_user, optional: true,
                             class_name: 'User'
  belongs_to :order, optional: true
  belongs_to :financial_reason
  belongs_to :currency
  belongs_to :bonus_commission, optional: true
  belongs_to :product, optional: true
  belongs_to :chargebacker_by_inactivity, class_name: 'FinancialTransaction',
                                          optional: true
  belongs_to :deposit, optional: true
  belongs_to :withdraw, optional: true

  has_one :chargeback_by_inactivity, foreign_key: 'chargebacker_by_inactivity_id',
                                     class_name: 'FinancialTransaction'

  validates :user_amount, numericality: true
  validates :admin_amount, numericality: true
  validates :system_amount, numericality: true
  validates :admin_cashflow, presence: true
  validates :system_cashflow, presence: true
  validates :user_cashflow, presence: true
  validates :financial_result_code, numericality: true,
                                    allow_blank: true

  scope :by_currency_id, -> (currency_id) { where(currency_id: currency_id) }
  scope :by_financial_reason_id, -> (id) { where(financial_reason_id: id) }
  scope :by_bonus_commission_id, -> (id) { where(bonus_commission_id: id) }
  scope :by_order_id, -> (id) { where(order_id: id) }
  scope :by_product_id, -> (id) { where(product_id: id) }
  scope :by_spreader_user_unique_attribute, -> (key) { where(spreader_user: User.by_unique_key(key)) }
  scope :by_created_at_between, -> (from, untill) { where(created_at: (from..untill)) }

  after_commit :chargeback_by_inactivity!, on: :create,
                                           if: :chargebackable_by_inactivity?

  def user_amount=(value)
    self[:user_amount] = (value.to_f * 1e8).to_i if FLOAT_NUMBER_REGEXP.match(value.to_s)
  end

  def user_amount
    self[:user_amount].to_f / 1e8 if self[:user_amount]
  end

  def admin_amount=(value)
    self[:admin_amount] = (value.to_f * 1e8).to_i if FLOAT_NUMBER_REGEXP.match(value.to_s)
  end

  def admin_amount
    self[:admin_amount].to_f / 1e8 if self[:admin_amount]
  end

  def system_amount=(value)
    self[:system_amount] = (value.to_f * 1e8).to_i if FLOAT_NUMBER_REGEXP.match(value.to_s)
  end

  def system_amount
    self[:system_amount].to_f / 1e8 if self[:system_amount]
  end

  def chargeback_by_inactivity!
    attrs = attributes.symbolize_keys.except(:id, :created_at, :updated_at)

    attrs.merge!(financial_reason: FinancialReason.chargeback_by_inactivity)
    attrs.merge!(user_amount: -user_amount,
                 admin_amount: -admin_amount,
                 system_amount: -system_amount)
    attrs.merge!(user_cashflow: cashflow_of_chargeback(user_cashflow))
    attrs.merge!(admin_cashflow: cashflow_of_chargeback(admin_cashflow))
    attrs.merge!(system_cashflow: cashflow_of_chargeback(system_cashflow))

    create_chargeback_by_inactivity!(attrs)
  end

  private

  def chargebackable_by_inactivity?
    financial_reason.try(:chargebackable_by_inactivity) &&
    chargebacker_by_inactivity.blank? &&
    user.try(:inactive?)
  end

  def cashflow_of_chargeback(current_cashflow)
    {
      not_applicable: :not_applicable,
      in: :out,
      out: :in
    }[current_cashflow.to_sym]
  end
end
