class UnilevelNode < ApplicationRecord
  has_ancestry(cache_depth: true)

  belongs_to :user
  belongs_to :sponsored, class_name: 'User'

  scope :by_ancestry_depth_until, -> (v) { where('unilevel_nodes.ancestry_depth <= ?', v) }
  scope :by_ancestry_depth, -> (v) { where('unilevel_nodes.ancestry_depth = ?', v) }
  scope :by_active_sponsored, -> { where(sponsored: User.active) }
  scope :by_inactive_sponsored, -> { where(sponsored: User.inactive) }
  scope :by_sponsored_created_at_between,
    ->(from, untill) { where(sponsored: User.created_at_between(from, untill)) }
  scope :by_user_unique_key, ->(key) { where(sponsored: User.by_unique_key(key)) }

  def self.network_head!
    UnilevelNode.where(user: User.root!, sponsored: User.network_head!).first ||
    UnilevelNode.create!(user: User.root!, sponsored: User.network_head!)
  end

  def sponsors_by_count(count)
    ancestors.includes(:sponsored)
             .order(id: :desc)
             .limit(count)
             .map(&:sponsored)
  end
end
