module Migrations
  module ModelMigrator
    def create_model_migration
      generate 'migration',
               "add_referral_fields_to_#{file_name} \
               last_prize_acquired_id:integer \
               referral_slug \
               referrals_count:integer"
      add_model_migration_details
    end

    private

    def add_model_migration_details
      return unless migration_created?('_add_referral_fields_to_user')
      constrain_count
      write_slug_data
      constrain_slug
    end

    def constrain_count
      inject_into_file(last_migration, after: '_count, :integer') do
        ', default: 0, null: false'
      end
    end

    def write_slug_data
      inject_into_file(last_migration, after: 'null: false') do
        <<~TEXT
        \n
            # Update each record with a slug
            #{class_name}.find_each do |#{file_name}|
              #{file_name}.valid?
              #{file_name}.update_attribute(:slug, #{file_name}.slug)
            end

            # Add constraint
        TEXT
      end
    end

    def constrain_slug
      inject_into_file(last_migration, after: 'Add constraint') do
        "\n    change_column_null :#{plural_name}, :referral_slug, false"
      end
    end
  end
end
