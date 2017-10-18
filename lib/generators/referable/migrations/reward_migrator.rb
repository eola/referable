module Migrations
  module RewardMigrator

    def create_reward_migration
      generate 'migration', "create_referable_rewards"
      add_reward_migration_details
    end

    private

    def add_reward_migration_details
      return unless migration_created?('create_referable_rewards')
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
