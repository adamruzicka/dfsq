require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
# require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
require "rails/test_unit/railtie"

require 'sequel'
require 'dynflow'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Dfsq
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w(assets tasks))

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    # Use Dynflow as the backend for ActiveJob
    # config.active_job.queue_adapter = :dynflow

    config.after_initialize do
      init_dynflow unless in_rake?('db:create') || in_rake?('db:drop')
    end

    def dynflow
      @dynflow ||= ::Dynflow::Rails.new().tap(&:require!)
    end

    def init_dynflow
      dynflow.eager_load_actions!
    end

    def self.in_rake?(*rake_tasks)
      return false unless defined?(Rake) && Rake.respond_to?(:application)
      Rake.application.top_level_tasks.any? do |running_rake_task|
        rake_tasks.empty? || rake_tasks.any? { |rake_task| running_rake_task.start_with?(rake_task) }
      end
    end
  end
end
