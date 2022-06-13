class Withdraw < ApplicationRecord
  enum status: { confirmation: 0, created: 1, paying: 2, paid: 3, canceled: 4 }

  belongs_to :user
  belongs_to :currency
  belongs_to :admin_user, foreign_key: :updater_admin_user,
                          optional: true
  belongs_to :receivable_method, polymorphic: true

  has_many :financial_transactions

  validates :gross_amount, presence: true,
                           numericality: { greater_than: 0 }
  validates :net_amount, presence: true,
                         numericality: { greater_than_or_equal_to: 0 }
  validates :receivable_currency_amount, presence: true,
                                         numericality: { greater_than_or_equal_to: 0 }

  scope :by_statuses, -> (statuses) { where(status: statuses) }
  scope :by_currency_ids, -> (ids) { where(currency_id: ids) }
  scope :by_receivable_method_types, -> (types) { where(receivable_method_type: types) }
  scope :created_at_between, ->(from, untill) { where(created_at: (from..untill)) }

  def gross_amount=(value)
    self[:gross_amount] = (value.to_f * 1e8).to_i if FLOAT_NUMBER_REGEXP.match(value.to_s)
  end

  def gross_amount
    self[:gross_amount].to_f / 1e8 if self[:gross_amount]
  end

  def net_amount=(value)
    self[:net_amount] = (value.to_f * 1e8).to_i if FLOAT_NUMBER_REGEXP.match(value.to_s)
  end

  def net_amount
    self[:net_amount].to_f / 1e8 if self[:net_amount]
  end

  def fee=(value)
    self[:fee] = (value.to_f * 1e8).to_i if FLOAT_NUMBER_REGEXP.match(value.to_s)
  end

  def fee
    self[:fee].to_f / 1e8 if self[:fee]
  end

  def receivable_currency_amount=(value)
    self[:receivable_currency_amount] = (value.to_f * 1e8).to_i if FLOAT_NUMBER_REGEXP.match(value.to_s)
  end

  def receivable_currency_amount
    self[:receivable_currency_amount].to_f / 1e8 if self[:receivable_currency_amount]
  end

  def confirmation_url(url)
    add_param_to_url(:confirmation_token, url)
  end

  private

  def add_param_to_url(param_name, url)
    return if !url.match?(URL_REGEXP)

    uri = URI(url)
    query = uri.query.to_s
    query += '&' if query.present?
    query += "#{param_name}=#{read_attribute(param_name)}"
    uri.query = query

    uri.to_s
  end
end
