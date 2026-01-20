# frozen_string_literal: true

Sentry.init do |config|
  config.dsn = ENV['GLITCHTIP_DSN']
  config.environment = ENV['SENTRY_CURRENT_ENV']

  # Additionally exclude the following exceptions:
  # config.excluded_exceptions += []

  # do not send list of gem dependencies
  config.send_modules = false

  # Whether to capture local variables from the raised exceptions frame.
  config.include_local_variables = true

  config.breadcrumbs_logger = %i[active_support_logger http_logger]

  # Add data like request headers and IP for users, if applicable;
  # see https://docs.sentry.io/platforms/ruby/data-management/data-collected/ for more info
  config.send_default_pii = true

  # Sentry automatically sets the current environment from the environment variables:
  # SENTRY_CURRENT_ENV, SENTRY_ENVIRONMENT, RAILS_ENV, RACK_ENV in that order and
  # defaults to development
  # config.environment = Rails.env

  config.release = ENV['BUILD_COMMIT']


  filter = ActiveSupport::ParameterFilter.new(Rails.application.config.filter_parameters)

  config.before_send = lambda do |event, _hint|
    event.extra = filter.filter(event.extra) if event.extra
    event.user = filter.filter(event.user) if event.user
    event.contexts = filter.filter(event.contexts) if event.contexts

    # Add transaction name because it's not displayed otherwise in glitchtip
    event.tags[:transaction] ||= event.transaction if event.transaction

    event
  end
end
