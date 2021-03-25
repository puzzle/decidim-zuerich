if Rails.application.secrets.dig(:omniauth, :oidc).present?
  Rails.application.config.middleware.use OmniAuth::Builder do
    provider(
        :oidc,
        setup: ->(env) {
          request = Rack::Request.new(env)
          organization = Decidim::Organization.find_by(host: request.host)
          provider_config = organization.enabled_omniauth_providers[:oidc]
          env["omniauth.strategy"].options[:client_options] ||= {}
          env["omniauth.strategy"].options[:client_options][:identifier] = provider_config[:client_id]
          env["omniauth.strategy"].options[:client_options][:secret] = provider_config[:client_id]
          #env["omniauth.strategy"].options[:client_options][:redirect_uri] = user_oidc_omniauth_callback
          env["omniauth.strategy"].options[:client_options][:redirect_uri] = 'https://mitwirken.stadt-zuerich.ch/users/auth/oidc/callback'
        },
        name: :oidc,
        #issuer: Rails.env.production? ? 'https://login.stadt-zuerich.ch:443/login/op' : 'https://login.integ.stadt-zuerich.ch:443/login/op',
        issuer: 'https://login.stadt-zuerich.ch:443/login/op',
        discovery: true,
        client_auth_method: :jwks,
        scope: [:openid, :stzh_profile_basic],
    )
  end
end
