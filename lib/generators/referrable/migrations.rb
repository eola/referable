module Migrations
  require_relative './migrations/model_migrator'
  require_relative './migrations/reward_migrator'

  include ModelMigrator
  include PrizeMigrator

  def migration_created?(migration_name)
    /#{migration_name}/ =~ last_migration
  end

  def last_migration
    Dir['db/migrate/*'].last
  end
end
