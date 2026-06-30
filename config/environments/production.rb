require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  # Ensures that a master key has been made available in ENV["RAILS_MASTER_KEY"], config/master.key, or an environment
  # key such as config/credentials/production.key. This key is used to decrypt credentials (and other encrypted files).
  # config.require_master_key = true

  # Disable serving static files from `public/`, relying on NGINX/Apache to do so instead.
  # config.public_file_server.enabled = false
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # Compress CSS using a preprocessor.
  # 

  # Do not fall back to assets pipeline if a precompiled asset is missed.
  

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  config.asset_host = ENV['RAILS_ASSET_HOST'] if ENV['RAILS_ASSET_HOST'].present?

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for Apache
  # config.action_dispatch.x_sendfile_header = "X-Accel-Redirect" # for NGINX

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = Decidim::Env.new("STORAGE_PROVIDER", "local").to_s

  # Mount Action Cable outside main process or domain.
  # config.action_cable.mount_path = nil
  # config.action_cable.url = "wss://example.com/cable"
  # config.action_cable.allowed_request_origins = [ "http://example.com", /http:\/\/example.*/ ]

  # Assume all access to the app is happening through a SSL-terminating reverse proxy.
  # Can be used together with config.force_ssl for Strict-Transport-Security and secure cookies.
  # config.assume_ssl = true

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = true

  # Skip http-to-https redirect for the default health check endpoint.
  # config.ssl_options = { redirect: { exclude: ->(request) { request.path == "/up" } } }

  if ENV["RAILS_LOG_TO_STDOUT"].present?
  config.logger = ActiveSupport::Logger.new(STDOUT)
    .tap  { |logger| logger.formatter = ::Logger::Formatter.new }
    .then { |logger| ActiveSupport::TaggedLogging.new(logger) }
end

  # Prepend all log lines with the following tags.
  config.log_tags = [ :request_id ]
  config.action_mailer.smtp_settings = {
    :address        => Decidim::Env.new("SMTP_ADDRESS").to_s,
    :port           => Decidim::Env.new("SMTP_PORT", 587).to_i,
    :authentication => Decidim::Env.new("SMTP_AUTHENTICATION", "plain").to_s,
    :user_name      => Decidim::Env.new("SMTP_USERNAME").to_s,
    :password       => Decidim::Env.new("SMTP_PASSWORD").to_s,
    :domain         => Decidim::Env.new("SMTP_DOMAIN").to_s,
    :enable_starttls_auto => Decidim::Env.new("SMTP_STARTTLS_AUTO", true).present?,
    :openssl_verify_mode => 'none'
  }

  # "info" includes generic and useful information about system operation, but avoids logging too much
  # information to avoid inadvertent exposure of personally identifiable information (PII). If you
  # want to log everything, set the level to "debug".
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # Use a different cache store in production.
  memcached_host = ENV['RAILS_MEMCACHED_HOST'] || 'localhost'
  memcached_port = ENV['RAILS_MEMCACHED_PORT'] || '11211'
  config.cache_store = :mem_cache_store, "#{memcached_host}:#{memcached_port}"

  # Use a real queuing backend for Active Job (and separate queues per environment).
  config.active_job.queue_adapter = ENV['QUEUE_ADAPTER'] if ENV['QUEUE_ADAPTER'].present?
  # config.active_job.queue_name_prefix = "decidim_development_app_production"

  # Disable caching for Action Mailer templates even if Action Controller
  # caching is enabled.
  config.action_mailer.perform_caching = false

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  # Don't log any deprecations.
  config.active_support.report_deprecations = false

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  # Mail Settings
  if ENV['RAILS_MAIL_DELIVERY_CONFIG'].present?
    case config.action_mailer.delivery_method.to_s
    when 'smtp'
      config.action_mailer.smtp_settings =
        YAML.safe_load("{ #{ENV['RAILS_MAIL_DELIVERY_CONFIG']} }")
            .symbolize_keys
    when 'sendmail'
      config.action_mailer.sendmail_settings =
        YAML.safe_load("{ #{ENV['RAILS_MAIL_DELIVERY_CONFIG']} }")
            .symbolize_keys
    end
  else
    config.action_mailer.smtp_settings = { address: '127.0.0.1', port: 1025 }
  end

  config.aspsms = {
    user_key: ENV['ASPSMS_API_USER_KEY'],
    password: ENV['ASPSMS_API_PASSWORD'],
    affiliate_id: ENV['ASPSMS_AFFILIATE_ID']
  }

  # Only use :id for inspections in production.
  config.active_record.attributes_for_inspect = [ :id ]

  # Enable DNS rebinding protection and other `Host` header attacks.
  # config.hosts = [
  #   "example.com",     # Allow requests from example.com
  #   /.*\.example\.com/ # Allow requests from subdomains like `www.example.com`
  # ]
  # Skip DNS rebinding protection for the default health check endpoint.
  # config.host_authorization = { exclude: ->(request) { request.path == "/up" } }

  # Custom

  # Disable Deface dynamic overrides, and use precompiled files. 
  # to compile: `SKIP_MEMCACHE_CHECK=1 DEFACE_ENABLED=1 bundle exec rails deface:precompile`
  # to check compiled views: `./app/compiled_views`
  config.deface.enabled = ENV.fetch("DEFACE_ENABLED", "0") == '1'

  # Use log rage
  enabled = ENV.fetch('RAILS_LOGRAGE_ENABLED', 'true')
  config.lograge.enabled = ActiveModel::Type::Boolean.new.cast(enabled)
  config.lograge.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new($stdout))

  # Lograge only detaches ActionController/ActionView subscribers. Mute the other
  # noisy INFO-level loggers (cells, jobs, mailer) when it's active.
  if config.lograge.enabled
    config.after_initialize do
      ActiveSupport::Notifications.unsubscribe "render_cell.action_view"
    end
    config.active_job.logger = nil
    config.action_mailer.logger = nil
  end
  config.lograge.ignore_actions = ['StatusController#health', 'StatusController#readiness']
  config.lograge.custom_payload do |controller|
    {
      host: controller.request.host,
      user_id: controller.current_user.try(:id)
    }
  end
  config.lograge.custom_options = lambda do |event|
    exceptions = %w[controller action format id]
    {
      time: Time.zone.now.utc,
      params: event.payload[:params].except(*exceptions)
    }
  end
end
