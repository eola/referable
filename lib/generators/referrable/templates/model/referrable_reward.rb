class ReferrableReward < ApplicationRecord

  enum acquireable_by: [], _prefix: :acquireable_by

  validates :referrals_required, uniqueness: {
    scope: :acquireable_by, message: 'Target aleady present for this kind of reward'
  }

  def self.best_reward(acquireable_by)
    where(acquireable_by: acquireable_by).order(referrals_required: :desc).first
  end

  def self.zeroth_tier(acquireable_by)
    zeroth = find_by(referrals_required: 0, acquireable_by: acquireable_by)
    return zeroth if zeroth
    create!(reward: 'none', referrals_required: 0, acquireable_by: acquireable_by)
  end

  def next_reward(above: 0)
    query = self.class
                .where(acquireable_by: acquireable_by)
                .where('referrals_required > ?', referrals_required)
                .where('referrals_required >= ?', above)
                .order(referrals_required: :asc)
                .limit(1)
    query.any? ? query.first : self
  end

  def previous_reward(below: 10e5)
    query = self.class
                .where(acquireable_by: acquireable_by)
                .where('referrals_required < ?', referrals_required)
                .where('referrals_required <= ?', below)
                .order(referrals_required: :desc)
                .limit(1)
    query.any? ? query.first : self
  end

end
