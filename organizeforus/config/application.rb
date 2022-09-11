require_relative "boot"

require "rails/all"
require "active_storage/engine"

#prove
#stylesheet_link_tag 'application'
#stylesheet_link_tag 'homepage.css'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Organizeforus
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.assets.enabled = true
    config.exceptions_app = self.routes
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.active_record.verify_foreign_keys_for_fixtures = false

    #PARTE PER CANARD
    # Don't generate system test files.
    #config.generators.system_tests = nil
    config.generators do |g|
    g.test_framework = false
    end

  end
end