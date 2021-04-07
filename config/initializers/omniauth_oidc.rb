if Rails.application.secrets.dig(:omniauth, :oidc).present?
  Rails.application.config.middleware.use OmniAuth::Builder do
    provider(
        :oidc,
        setup: ->(env) {
          request = Rack::Request.new(env)
          organization = Decidim::Organization.find_by(host: request.host)
          provider_config = organization.enabled_omniauth_providers[:oidc]
          env["omniauth.strategy"].options[:client_options] ||= {}
          env["omniauth.strategy"].options[:issuer] = provider_config[:issuer]
          env["omniauth.strategy"].options[:client_options][:identifier] = provider_config[:client_id]
          env["omniauth.strategy"].options[:client_options][:secret] = provider_config[:client_secret]
          env["omniauth.strategy"].options[:client_options][:redirect_uri] = provider_config[:redirect_url]
        },
        name: :oidc,
        discovery: true,
        client_auth_method: :basic,
        scope: [:openid, :stzh_profile_basic],
    )
  end
end
