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

  def set_sentry_context
    Raven.user_context(sentry_user_context)
    Raven.extra_context(sentry_extra_context)
    Raven.context.tags = Raven.context.tags.deep_merge(sentry_tags)
  end

  def sentry_user_context
    return {} unless (key = session['warden.user.user.key'].presence)
    return {} unless (user = Decidim::User.serialize_from_session(*key))

    {
      id: user.id,
      username: user.name,
      email: user.email,
      ip: request.remote_ip
    }
  end

  def sentry_extra_context
    {
      params: params.to_unsafe_h,
      url: request.url
    }
  end

  def sentry_tags
    {
      locale: session['user_locale']
    }
  end
end
