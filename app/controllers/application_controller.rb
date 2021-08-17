class ApplicationController < ActionController::Base
  before_action :set_sentry_context

  private

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
