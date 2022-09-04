require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

key_file = File.join "config", "master.key"
if File.exist? key_file
  ENV["RAILS_MASTER_KEY"] = File.read key_file
end

module MandarinOnRails
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    
    #config.after_initialize do
    #  # use this for turbo-rails version 0.8.2 or later:
    #  config.assets.precompile -= Turbo::Engine::PRECOMPILE_ASSETS
    #end

    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.autoload_paths << "#{Rails.root}/lib"
  end
end
