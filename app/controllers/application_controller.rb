class ApplicationController < ActionController::Base
  before_action :set_sentry_context

  around_action :global_request_logging

  private

  def global_request_logging
    # http_request_header_keys = request.headers.env.keys.select{|header_name| header_name.match("^HTTP.*|^X-User.*")}
    # http_request_headers = request.headers.env.select{|header_name, header_value| http_request_header_keys.index(header_name)}
    hash = {
      request_method: request.method,
      ip: request.ip,
      remote_ip: request.remote_ip,
      url: request.url,
      fullpath: request.fullpath,
      user_agent: ('"' + request.user_agent.to_s + '"'),
      headers: request.headers.env.reject { |key| key.to_s.include?('.') },
      params: params.to_enum.to_h
    }

    msg = Hash[*hash.sort.flatten]

    logger = Logger.new('log/request.log')
    logger.info(msg)
  end

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
