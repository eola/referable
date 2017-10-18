module Referable
  extend ActiveSupport::Concern

  included do
    has_many   :referrals, as: :referrer
    has_many   :recruits, through: :referrals, source_type: name
    belongs_to :last_reward_acquired,
               class_name: 'ReferableReward',
               default: -> { ReferableReward.zeroth_tier(self.class.name.downcase) }

    before_save :add_referral_slug
  end

  def percent_to_next_reward
    last_tier_count = last_reward_acquired.referrals_required
    next_tier_count = last_reward_acquired
                        .next_reward(above: referrals.size)
                        .referrals_required - last_tier_count
    current_count = referrals.size - last_tier_count
    (current_count.to_f / next_tier_count) * 100
  end

  def distance_to_next_reward
    last_reward_acquired
      .next_reward(above: referrals.size)
      .referrals_required - referrals.size
  end

  def acquired_reward!
    update!(last_reward_acquired: last_reward_acquired.next_reward(above: referrals.size))
  end

  def increment!(attribute, by = 1)
    super
    check_for_new_reward
  end

  private

  def check_for_new_reward
    count = referrals.size
    if count >= last_reward_acquired.next_reward(above: count).referrals_required
      acquired_reward!
    end
  end

  def add_referral_slug
    self.referral_slug = create_referral_slug unless referral_slug
  end

  def create_referral_slug
    slug = Utilities.generate_friendly_chars(3)
    self.class.exists?(referral_slug: slug) ? create_referral_slug : slug
  end
end
