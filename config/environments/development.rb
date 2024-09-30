# frozen_string_literal: true

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  config.action_controller.perform_caching = if Rails.root.join('tmp', 'caching-dev.txt').exist?
                                               true

                                             # config.cache_store = :memory_store
                                             # config.public_file_server.headers = {
                                             #   'Cache-Control' => "public, max-age=#{2.days.to_i}"
                                             # }
                                             else
                                               false

                                               # config.cache_store = :null_store
                                             end
  memcached_host = ENV['RAILS_MEMCACHED_HOST'] || 'localhost'
  memcached_port = ENV['RAILS_MEMCACHED_PORT'] || '11211'
  config.cache_store = :mem_cache_store, "#{memcached_host}:#{memcached_port}"
  # Silence the cache store, the decidim-term_customizer module doesn't work otherwise
  config.after_initialize do
    # Rails.cache.logger.level = Logger::INFO
  end

  # Store uploaded files on the local file system (see config/storage.yml for options)
  config.active_storage.service = :local

  # Use mailcatcher
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: ENV['RAILS_SMTP_ADDRESS'] || '127.0.0.1',
    port: ENV['RAILS_SMTP_PORT'] || 1025
  }

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { port: 3000 }

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true
  config.action_view.raise_on_missing_translations = false

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  config.aspsms = {
    user_key: ENV.fetch('ASPSMS_API_USER_KEY', nil),
    password: ENV.fetch('ASPSMS_API_PASSWORD', nil),
    affiliate_id: ENV.fetch('ASPSMS_AFFILIATE_ID', nil)
  }

  config.hosts << /.*\.local/
end
