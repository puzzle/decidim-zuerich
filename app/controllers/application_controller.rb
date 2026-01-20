# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_sentry_context
  before_action :set_cache_headers

  # Used for request debugging
  # around_action :global_request_logging

  private

  def set_cache_headers
    response.headers['Cache-Control'] = 'no-cache, no-store'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = 'Mon, 01 Jan 1990 00:00:00 GMT'
  end

  def set_sentry_context
    return unless ENV['GLITCHTIP_DSN']

    commit = ENV['BUILD_COMMIT']
    project = ENV['PROJECT'] || ENV['RAILS_DB_NAME']
    customer = ENV['CUSTOMER'] || project&.split('_')[1]
    
    Sentry.set_tags(commit: commit) if commit
    Sentry.set_tags(project: project) if project
    Sentry.set_tags(customer: customer) if customer

    Sentry.set_user(
      id: current_user.try(:id),
      username: current_user.try(:name),
      email: current_user.try(:email)
    )

    # Capture users locale
    Sentry.set_tags(locale: session['user_locale'])
  end

  # Used for request debugging
  # def global_request_logging
  #   msg = Hash[*log_info.sort.flatten]

  #   logger = Logger.new('log/request.log')
  #   logger.info(msg)
  # end

  # # Used for request debugging
  # def log_info
  #   {
  #     request_method: request.method,
  #     ip: request.ip,
  #     remote_ip: request.remote_ip,
  #     url: request.url,
  #     fullpath: request.fullpath,
  #     user_agent: request.user_agent.to_s,
  #     headers: request_headers(request),
  #     params: request_params(params)
  #   }
  # end

  # # Used for request debugging
  # def request_headers(request)
  #   request
  #     .headers
  #     .env
  #     .except(*%w[warden HTTP_COOKIE])
  #     .reject { |key| key.to_s.include?('.') }
  # end

  # # Used for request debugging
  # def request_params(params)
  #   params.to_enum.to_h
  # end
end
