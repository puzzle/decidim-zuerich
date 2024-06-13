Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.cache_classes = true

  config.force_ssl = true
  # Disable Deface dynamic overrides, and use precompiled files. 
  # to compile: `SKIP_MEMCACHE_CHECK=1 DEFACE_ENABLED=1 bundle exec rails deface:precompile`
  # to check compiled views: `./app/compiled_views`
  config.deface.enabled = ENV.fetch("DEFACE_ENABLED", "0") == '1'

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Ensures that a master key has been made available in either ENV["RAILS_MASTER_KEY"]
  # or in config/master.key. This key is used to decrypt credentials (and other encrypted files).
  # config.require_master_key = true

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.action_controller.asset_host = 'http://assets.example.com'

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = 'X-Sendfile' # for Apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX

  # Store uploaded files on the local file system (see config/storage.yml for options)
  config.active_storage.service = :ocp4_s3

  # Mount Action Cable outside main process or domain
  # config.action_cable.mount_path = nil
  # config.action_cable.url = 'wss://example.com/cable'
  # config.action_cable.allowed_request_origins = [ 'http://example.com', /http:\/\/example.*/ ]

  # Use the lowest log level to ensure availability of diagnostic information
  # when problems arise.
  #config.log_level = :debug
  # Use a more conservative log level for now, because lograge does not work (?)
  config.log_level = :info

  # Prepend all log lines with the following tags.
  config.log_tags = [ :request_id ]

  # Use a different cache store in production.
  memcached_host = ENV['RAILS_MEMCACHED_HOST'] || 'localhost'
  memcached_port = ENV['RAILS_MEMCACHED_PORT'] || '11211'
  config.cache_store = :mem_cache_store, "#{memcached_host}:#{memcached_port}"
  # Silence the cache store, the decidim-term_customizer module doesn't work otherwise
  config.after_initialize do
    # Rails.cache.logger.level = Logger::INFO
  end

  config.action_mailer.perform_caching = false

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # Use a different logger for distributed setups.
  # require 'syslog/logger'
  # config.logger = ActiveSupport::TaggedLogging.new(Syslog::Logger.new 'app-name')

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

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

  # config.action_mailer.smtp_settings = {
  #   :address        => Rails.application.secrets.smtp_address,
  #   :port           => Rails.application.secrets.smtp_port,
  #   :authentication => Rails.application.secrets.smtp_authentication,
  #   :user_name      => Rails.application.secrets.smtp_username,
  #   :password       => Rails.application.secrets.smtp_password,
  #   :domain         => Rails.application.secrets.smtp_domain,
  #   :enable_starttls_auto => Rails.application.secrets.smtp_starttls_auto,
  #   :openssl_verify_mode => 'none'
  # }

  config.aspsms = {
      user_key: ENV['ASPSMS_API_USER_KEY'],
      password: ENV['ASPSMS_API_PASSWORD'],
      affiliate_id: ENV['ASPSMS_AFFILIATE_ID']
  }

  # Use log rage
  enabled = ENV.fetch('RAILS_LOGRAGE_ENABLED', 'true')
  config.lograge.enabled = ActiveModel::Type::Boolean.new.cast(enabled)
  config.lograge.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new($stdout))
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
