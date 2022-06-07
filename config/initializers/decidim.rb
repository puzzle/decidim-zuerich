# frozen_string_literal: true

# Inform Decidim about the assets folder
if Decidim.respond_to?(:register_assets_path)
  Decidim.register_assets_path File.expand_path("app/packs", Rails.application.root)
end

Decidim.configure do |config|
  config.application_name = 'DecidimZuerich'
  config.mailer_sender = 'info@puzzle.ch'
  config.mailer_reply = 'mitwirken-kontakt@zuerich.ch'

  # Change these lines to set your preferred locales
  config.default_locale = :de
  config.available_locales = %i[en de fr it]

  config.maps = {
      dynamic: {
          provider: :gis_zh,
          # provider: :swisstopo,
          default_center: {
              lat: 47.378,
              lng: 8.540
          },
          map_limits: {
              lat_min: 47.312,
              lat_max: 47.442,
              lng_min: 8.43,
              lng_max: 8.64
          },
          layers: {
              '0': {
                  name: ->(*_args) { I18n.t('decidim_zuerich.maps.gis_zh.basiskarte_schraeg') },
                  url: 'https://www.ogc.stadt-zuerich.ch/mapproxy/wmts/1.0.0/basiskarte_zuerich_gebaeudeschraegansicht/default/ktzh/{z}/{y}/{x}.png'
              },
          }
      },
      static: false,
      geocoding: {
          provider: :osm,
          timeout: 5,
          units: :km,
      },
      autocomplete: {
          provider: :osm,
          url: "https://photon.komoot.io/api?lat=47.378&lon=8.540&bbox=8.43,47.312,8.64,47.442",
          address_format: [
              "name",
              ["street", "housenumber"],
              "postcode",
              "city",
          ]
      }
  }

  # Geocoder configuration
  config.geocoder = {
    static_map_url: "https://image.maps.cit.api.here.com/mia/1.6/mapview",
  }

  # Custom resource reference generator method
  # config.reference_generator = lambda do |resource, component|
  #   # Implement your custom method to generate resources references
  #   "1234-#{resource.id}"
  # end

  # Currency unit
  config.currency_unit = "CHF"

  # Disable the default redirect to https, since we use nginx for ssl termination
  config.force_ssl = false

  # The number of reports which an object can receive before hiding it
  # config.max_reports_before_hiding = 3

  # Custom HTML Header snippets
  #
  # The most common use is to integrate third-party services that require some
  # extra JavaScript or CSS. Also, you can use it to add extra meta tags to the
  # HTML. Note that this will only be rendered in public pages, not in the admin
  # section.
  #
  # Before enabling this you should ensure that any tracking that might be done
  # is in accordance with the rules and regulations that apply to your
  # environment and usage scenarios. This component also comes with the risk
  # that an organization's administrator injects malicious scripts to spy on or
  # take over user accounts.
  #
  config.enable_html_header_snippets = true

  # SMS gateway configuration
  #
  # If you want to verify your users by sending a verification code via
  # SMS you need to provide a SMS gateway service class.
  #
  # An example class would be something like:
  #
  # class MySMSGatewayService
  #   attr_reader :mobile_phone_number, :code
  #
  #   def initialize(mobile_phone_number, code)
  #     @mobile_phone_number = mobile_phone_number
  #     @code = code
  #   end
  #
  #   def deliver_code
  #     # Actual code to deliver the code
  #     true
  #   end
  # end
  #
  config.sms_gateway_service = "DecidimZuerich::Verifications::Sms::AspsmsGateway"

  # Timestamp service configuration
  #
  # Provide a class to generate a timestamp for a document. The instances of
  # this class are initialized with a hash containing the :document key with
  # the document to be timestamped as value. The istances respond to a
  # timestamp public method with the timestamp
  #
  # An example class would be something like:
  #
  # class MyTimestampService
  #   attr_accessor :document
  #
  #   def initialize(args = {})
  #     @document = args.fetch(:document)
  #   end
  #
  #   def timestamp
  #     # Code to generate timestamp
  #     "My timestamp"
  #   end
  # end
  #
  # config.timestamp_service = "MyTimestampService"

  # PDF signature service configuration
  #
  # Provide a class to process a pdf and return the document including a
  # digital signature. The instances of this class are initialized with a hash
  # containing the :pdf key with the pdf file content as value. The instances
  # respond to a signed_pdf method containing the pdf with the signature
  #
  # An example class would be something like:
  #
  # class MyPDFSignatureService
  #   attr_accessor :pdf
  #
  #   def initialize(args = {})
  #     @pdf = args.fetch(:pdf)
  #   end
  #
  #   def signed_pdf
  #     # Code to return the pdf signed
  #   end
  # end
  #
  # config.pdf_signature_service = "MyPDFSignatureService"

  # Etherpad configuration
  #
  # Only needed if you want to have Etherpad integration with Decidim. See
  # Decidim docs at docs/services/etherpad.md in order to set it up.
  #
  # config.etherpad = {
  #   server: Rails.application.secrets.etherpad[:server],
  #   api_key: Rails.application.secrets.etherpad[:api_key],
  #   api_version: Rails.application.secrets.etherpad[:api_version]
  # }
end

Rails.application.config.i18n.available_locales = Decidim.available_locales
Rails.application.config.i18n.default_locale = Decidim.default_locale
