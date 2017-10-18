module Migrations
  module PrizeMigrator

    def create_prize_migration
      generate 'migration', "create_referrable_rewards"
      add_reward_migration_details
    end

    private

    def add_reward_migration_details
      return unless migration_created?('create_referrable_rewards')
      inject_into_file(last_migration, after: 'do |t|') do
        <<~TEXT
        \n
              t.string "reward", null: false
              t.integer "referrals_required", null: false
              t.integer "acquireable_by", null: false
              t.timestamps
        TEXT
      end
    end
  end
end
