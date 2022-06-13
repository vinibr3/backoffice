class RuleRuleable < ApplicationRecord
  belongs_to :rule
  belongs_to :ruleable, polymorphic: true
  belongs_to :admin_user, foreign_key: :inactivator_id,
                          optional: true

  validates :inactive_at, presence: true, if: :inactivator?

  def inactivator?
    !!inactivator_id
  end
end
