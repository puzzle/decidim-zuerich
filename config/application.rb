# frozen_string_literal: true

require_relative 'boot'

require "decidim/rails"
# Add the frameworks used by your app that are not loaded by Decidim.
require "action_cable/engine"
# require "action_mailbox/engine"
# require "action_text/engine"

require 'rack/attack'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DecidimZuerich
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.autoloader = :zeitwerk

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Fall back to german and then to english if some translation does not exist
    config.i18n.fallbacks = [:de, :en]

    # Fix a weird interplay of anonymous proposals using deface, deface using I18n.transliterate,
    # I18n.transliterate using the term customizer and the term customizer wanting to access the
    # database, all during an assets:precompile...
    I18n.enforce_available_locales = false

    # This option silences the logging of Redirector related SQL queries in your log file
    # config.redirector.silence_sql_logs = true

    # Use a real queuing backend for Active Job (and separate queues per environment)
    config.active_job.queue_adapter     = :delayed_job
    config.active_job.queue_name_prefix = "decidim_zuerich_#{Rails.env}"

    config.middleware.use Rack::Attack

    Raven.configure do |config|
      config.dsn = ENV['SENTRY_DSN']
      config.current_environment = ENV['SENTRY_CURRENT_ENV']
    end
  end
end
