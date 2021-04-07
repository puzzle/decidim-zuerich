# frozen_string_literal: true

require 'addressable/uri'
require 'timeout'
require 'net/http'
require 'open-uri'
require 'omniauth'
require 'openid_connect'
require 'forwardable'

module OmniAuth
  module Strategies
    class Oidc < OmniAuth::Strategies::OpenIDConnect

      # Debug code
      # def initialize(*args)
      #   Rack::OAuth2.debug!
      #   super(*args)
      # end

      # Modification for Mein Konto:
      # Use our modified OAuth2 client (see below)
      def client
        @client ||= OidcClient.new(client_options)
      end

      # Modification for Mein Konto:
      # Don't perform any userinfo request, because Mein Konto does not support this endpoint.
      # Instead, just use the info already present in the id_token.
      def user_info
        return @user_info if @user_info
        return nil unless access_token.id_token

        decoded = decode_id_token(access_token.id_token).raw_attributes
        @user_info = ::OpenIDConnect::ResponseObject::UserInfo.new decoded
      end
    end

    class OidcClient < ::OpenIDConnect::Client

      def access_token!(*args)
        headers, params = {}, @grant.as_json
        http_client = Rack::OAuth2.http_client

        # NOTE:
        #  Using Array#extract_options! for backward compatibility.
        #  Until v1.0.5, the first argument was 'client_auth_method' in scalar.
        options = args.extract_options!

        # Simplification for Mein Konto:
        # We only use basic authentication, so no need to consider the configured client_auth_method
        #client_auth_method = args.first || options.delete(:client_auth_method).try(:to_sym) || :basic

        params[:scope] = Array(options.delete(:scope)).join(' ') if options[:scope].present?
        params.merge! options

        # Simplification for Mein Konto:
        # We only use basic authentication, so no need to consider the configured client_auth_method
        cred = Base64.strict_encode64 [
                                        # Modification for Mein Konto:
                                        # Don't URL encode the credentials.
                                        # The specifications are contradictory here, see
                                        # https://github.com/GluuFederation/oxAuth/issues/677#issuecomment-348350250
                                        #Util.www_form_url_encode(identifier),
                                        identifier,
                                        #Util.www_form_url_encode(secret)
                                        secret
                                    ].join(':')
        headers.merge!(
            'Authorization' => "Basic #{cred}"
        )

        handle_response do
          http_client.post(
              absolute_uri_for(token_endpoint),
              Rack::OAuth2::Util.compact_hash(params),
              headers
          )
        end
      end

    end
  end
end
