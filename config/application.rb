# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DecidimZuerich
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Precompile fonts
    config.assets.paths << Rails.root.join("app","assets","fonts")

    # Fall back to german and then to english if some translation does not exist
    config.i18n.fallbacks = [:de, :en]

    config.to_prepare do
      Rails.root.glob('app/overrides/**/*_override.rb').each do |override|
        require_dependency override
      end
    end
  end
end
