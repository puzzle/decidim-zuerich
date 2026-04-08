# frozen_string_literal: true

Decidim.configure do |config|
  # Map and Geocoder configuration
  #
  # See Decidim docs at https://docs.decidim.org/en/develop/services/maps
  # for more information about how it works and how to set it up.
  config.maps = {
    provider: :osm,
    api_key: false, # ENV["MAPS_API_KEY"]
    dynamic: {
      tile_layer: {
        url: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
        api_key: false,
        attribution: %(
          <a href="https://www.openstreetmap.org/copyright" target="_blank">&copy; OpenStreetMap</a> contributors
        ).strip
        # Translatable attribution:
        # attribution: -> { I18n.t("tile_layer_attribution") }
      }
    },
    # static: { url: "https://staticmap.example.org/" }, # optional
    geocoding: { host: 'nominatim.openstreetmap.org', use_https: true },
    autocomplete: {
      url: 'https://photon.komoot.io/api?lat=47.378&lon=8.540&bbox=8.43,47.312,8.64,47.442'
    }
  }

  config.geocoder = {
    static_map_url: 'https://image.maps.hereapi.com/mia/v3/base/mc/overlay'
  }

  config.content_security_policies_extra = {
    "connect-src" => "photon.komoot.io",
    "worker-src" => %w('self' blob:),
    "child-src" => %w('self' blob:)
  }

  config.omniauth_providers = {
    oidc: {
      enabled: Decidim::Env.new("MEIN_KONTO_ISSUER").to_boolean_string,
      issuer: ENV["MEIN_KONTO_ISSUER"],
      client_id: ENV["MEIN_KONTO_CLIENT_ID"],
      client_secret: ENV["MEIN_KONTO_CLIENT_SECRET"],
      redirect_url: ENV["MEIN_KONTO_REDIRECT_URL"],
      icon_path: "media/images/stadt-zuerich.svg"
    }
  }

  # SMS gateway configuration
  #
  # See Decidim docs at https://docs.decidim.org/en/develop/services/sms
  # for more information about how it works and how to set it up.
  config.sms_gateway_service = 'DecidimZuerich::Verifications::Sms::AspsmsGateway'

  # Machine Translation Configuration
  #
  # See Decidim docs at https://docs.decidim.org/en/develop/machine_translations/
  # for more information about how it works and how to set it up.
  config.enable_machine_translations = true

  config.machine_translation_delay = 0.seconds

  config.machine_translation_service = 'DecidimZuerich::MicrosoftTranslator'

  # Don't require changing passwords every 90 days, as this leads to worse security according to OWASP
  config.admin_password_expiration_days = 0
end
