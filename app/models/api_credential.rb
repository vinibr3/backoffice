class ApiCredential < ApplicationRecord
  SECRET = Rails.application.credentials.secret_key_base.freeze
  ALGORITM = 'HS256'.freeze

  belongs_to :user

  validates :key, presence: true
  validates :secret, presence: true

  def key=(value)
    self[:key] = JWT.encode(value, SECRET, ALGORITM) if value.present?
  end

  def secret=(value)
    self[:secret] = JWT.encode(value, SECRET, ALGORITM) if value.present?
  end

  def key
    JWT.decode(self[:key], SECRET, true, { algorithm: ALGORITM }).first if self[:key].present?
  end

  def secret
    JWT.decode(self[:secret], SECRET, true, { algorithm: ALGORITM }).first if self[:secret].present?
  end
end
