module Referrable
  extend ActiveSupport::Concern

  included do
    has_many   :referrals, as: :referrer
    has_many   :recruits, through: :referrals, source_type: name
    belongs_to :last_prize_acquired,
               class_name: 'ReferrablePrize',
               default: -> { ReferrablePrize.zeroth_tier(self.class.name.downcase) }

    before_save :add_referral_slug
  end

  def percent_to_next_prize
    last_tier_count = last_prize_acquired.referrals_required
    next_tier_count = last_prize_acquired
                        .next_prize(above: referrals.size)
                        .referrals_required - last_tier_count
    current_count = referrals.size - last_tier_count
    (current_count.to_f / next_tier_count) * 100
  end

  def distance_to_next_prize
    last_prize_acquired
      .next_prize(above: referrals.size)
      .referrals_required - referrals.size
  end

  def acquired_prize!
    update!(last_prize_acquired: last_prize_acquired.next_prize(above: referrals.size))
    AdminMessenger.instance.ping(
      "#{self.class.name} #{id} just won #{last_prize_acquired.prize}"
    )
  end

  def increment!(attribute, by = 1)
    super
    check_for_new_prize
  end

  private

  def check_for_new_prize
    count = referrals.size
    if count >= last_prize_acquired.next_prize(above: count).referrals_required
      acquired_prize!
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
