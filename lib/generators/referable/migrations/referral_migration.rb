module Migrations
  module ReferralMigrator

    def create_reward_migration
      generate 'migration', "create_referrals"
      add_referral_migration_details
    end

    private

    def add_referral_migration_details
      return unless migration_created?('create_referrals')
      inject_into_file(last_migration, after: 'do |t|') do
        <<~TEXT
        \n
            t.integer "recruit_id"
            t.datetime "created_at", null: false
            t.datetime "updated_at", null: false
            t.string "referrer_type"
            t.bigint "referrer_id"
            t.string "recruit_type"
            t.index ["recruit_type", "recruit_id"], name: "index_referrals_on_recruit_type_and_recruit_id"
            t.index ["referrer_type", "referrer_id"], name: "index_referrals_on_referrer_type_and_referrer_id"
        TEXT
      end
    end
  end
end
