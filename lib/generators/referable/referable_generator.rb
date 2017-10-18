require 'rails/generators/base'

class ReferableGenerator < Rails::Generators::NamedBase
  require_relative './migrations'

  include Migrations

  source_root File.expand_path('../templates', __FILE__)

  def copy_referral
    copy_file "model/referal.rb", "app/models/referral.rb"
  end

  def copy_referable_concern
    copy_file "concerns/referable.rb", "app/models/concerns/referable.rb"
    copy_file "model/referable_reward.rb", "app/models/referable_reward.rb"
  end

  def setup_migrations
    create_model_migration
    create_reward_migration
  end

  def include_concern_in_class
    inject_into_file "app/models/#{file_name}.rb", after: 'User < ApplicationRecord' do
      "\n  include Referable"
    end
  end

  def add_class_to_referable_reward
    symbol_in_array = acquireable_by_empty? ? ":#{file_name}" : ", :#{file_name}"
    inject_into_file('app/models/referable_reward.rb',
                     before: '], _prefix: :acquireable_by') { symbol_in_array }
  end

  private

  def acquireable_by_empty?
    File.read('app/models/referable_reward.rb').include? 'acquireable_by: []'
  end
end
