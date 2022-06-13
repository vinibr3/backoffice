class User < ApplicationRecord
  ACCEPTANCE_OPTIONS = ['1', true, 'true']

  has_secure_password

  attr_accessor :terms_of_service

  enum gender: { male: 0, female: 1 }

  has_one_attached :document_proove
  belongs_to :profile, optional: true
  belongs_to :admin_user, foreign_key: :compliance_admin_user_id,
                          optional: true
  has_one :unilevel_node, foreign_key: 'sponsored_id'
  has_one :sponsor, through: 'unilevel_node',
                    foreign_key: 'user_id',
                    source: 'user'
  has_one :address, as: :addressable
  has_many :unilevel_nodes
  has_many :sponsoreds, through: :unilevel_nodes,
                        class_name: 'User'
  has_many :deposits
  has_many :orders
  has_many :user_profiles
  has_many :financial_transactions
  has_many :api_credentials
  has_many :withdraws
  has_many :wallets
  has_many :pixes
  has_many :bank_accounts

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP },
                    length: { maximum: 255 },
                    allow_blank: true,
                    uniqueness: {case_sensitive: false}
  validates :terms_of_service, acceptance: { accept: ACCEPTANCE_OPTIONS }
  validates :terms_of_service_accepted_at, presence: true, if: :terms_of_service_accepted?
  validates :terms_of_service_accepted_ip, presence: true, if: :terms_of_service_accepted?
  validates :sponsor_token, presence: true,
                            length: { maximum: 255 }
  validates :provider, presence: true,
                       length: { maximum: 255 }
  validates :reset_password_token_sent_at, presence: true, if: proc { |u| u.reset_password_token.present? }
  validates :confirmation_token_sent_at, presence: true, if: proc { |u| u.confirmation_token.present? }
  validates :name, length: { maximum: 255 }
  validates :nickname, length: { maximum: 255 },
                       uniqueness: { case_sensitive: false },
                       allow_blank: true
  validates :document, length: { maximum: 255 },
                       uniqueness: { case_sensitive: false },
                       allow_blank: true
  validates :cellphone, length: { maximum: 255 },
                        uniqueness: { case_sensitive: false },
                        allow_blank: true
  validates :facebook, length: { maximum: 255 }
  validates :instagram, length: { maximum: 255 }
  validates :twitter, length: { maximum: 255 }
  validates :uid, length: { maximum: 255 }
  validates :confirmation_token, length: { maximum: 255 }
  validates :password, length: { minimum: 6, maximum: 255 },
                       allow_blank: proc { |u| u.password_digest.present? }
  validates :reset_password_token, length: { maximum: 255 }

  validate :presence_of_registration_attribute

  before_validation :assign_sponsor_token

  scope :active, -> { where('users.active_until_at >= ?', Time.now) }
  scope :inactive, -> { where('users.active_until_at < ?', Time.now) }
  scope :created_at_between, ->(from, untill) { where(created_at: (from..untill)) }
  scope :by_unique_key, -> (v) {
    query = []
    attributes = SystemParametrization.current.sign_in_attributes
    query = attributes.map { |a| "users.#{a} ILIKE ?" }.join(' OR ')

    values = attributes.map { |a| "%#{v}%" }

    where(query, *values)
  }

  def reset_password_link(url)
    add_param_to_url(:reset_password_token, url)
  end

  def confirmation_link(url)
    add_param_to_url(:confirmation_token, url)
  end

  def active?
    !inactive?
  end

  def inactive?
    return true if active_until_at.blank?

    active_until_at < Time.zone.now
  end

  def self.root!
    email = 'root@moretec.com.br'

    User.find_by(email: email) || User.create!(password: '111111',
                                               password_confirmation: '111111',
                                               email: email,
                                               nickname: 'root',
                                               cellphone: '9999999999',
                                               provider: 'email',
                                               document: '9999999999')
  end

  def self.network_head!
    email = 'user@moretec.com.br'

    User.find_by(email: email) || User.create!(password: '111111',
                                               password_confirmation: '111111',
                                               email: email,
                                               nickname: 'user',
                                               cellphone: '1111111111',
                                               provider: 'email',
                                               document: '1111111111')
  end

  private

  def terms_of_service_accepted?
    terms_of_service.in?(ACCEPTANCE_OPTIONS)
  end

  def presence_of_registration_attribute
    registration_attribute = SystemParametrization.current.registration_attribute.to_s.to_sym

    errors.add(registration_attribute, :blank) if self[registration_attribute].blank?
  end

  def assign_sponsor_token
    self[:sponsor_token] = SecureRandom.hex(5) if self[:sponsor_token].blank?
  end

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
