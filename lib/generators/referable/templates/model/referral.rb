class Referral < ApplicationRecord

  belongs_to :referrer, polymorphic: true, counter_cache: true
  belongs_to :recruit, polymorphic: true

end
