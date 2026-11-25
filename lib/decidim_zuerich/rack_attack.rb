# frozen_string_literal: true

require 'active_support/parameter_filter'

module DecidimZuerich
  # Simplifies common Rack::Attack rules
  class RackAttack
    class << self
      def enabled?
        ENV.fetch('ENABLE_RACK_ATTACK', Rails.env.production?.to_s)
           .in?(%w[true 1])
      end

      def debug?
        ENV.fetch('RACK_ATTACK_DEBUG', 'false')
           .in?(%w[true 1])
      end

      # Pass the original string through: IPAddr#to_s drops the prefix, which would
      # silently turn a safelisted 10.0.0.0/8 into the single host 10.0.0.0.
      def safelist_ips_from_env(env = 'RACK_ATTACK_SAFELIST_IPS')
        ENV.fetch(env, '')
           .split(',')
           .map(&:strip)
           .compact_blank
           .select { validate_ip(_1) }
           .each { Rack::Attack.safelist_ip(_1) }
      end

      def register_allow2ban_filter_from_env(name, env, **default)
        raise ArgumentError, 'I need a block to run!' unless block_given?

        options =
          { maxretry: 5, findtime: 10.minutes, bantime: 1.hour }
          .merge(default)
          .merge(env_to_h(env))

        Rack::Attack.blocklist(name) do |req|
          Rack::Attack::Allow2Ban.filter(req.ip, options) do
            yield(req)
          end
        end
      end

      def register_s3_redirects
        Rack::Attack.safelist 'allow S3 redirects' do |request|
          regexes = [
            %r{\Ahttps://[^/]+?/rails/active_storage/blobs/redirect/[A-Za-z0-9=]+--[A-Za-z0-9=]+/},
            %r{\Ahttps://[^/]+?/rails/active_storage/representations/redirect/[A-Za-z0-9=]+--[A-Za-z0-9=]+/[A-Za-z0-9=]+--[A-Za-z0-9=]+/}
          ]

          regexes.any? { _1.match? request.url }
        end
      end

      def subscribe_to_notifications
        ActiveSupport::Notifications.subscribe(/rack_attack/) do |name, _start, _finish, _request_id, payload|
          # Safelist matches are normal traffic (S3 redirects, office IPs); only log what was stopped.
          next if payload[:request].env['rack.attack.match_type'] == :safelist

          Rails.logger.warn "RACK ATTACK MATCH: #{match_fields(name, payload[:request])}"
        end
      end

      private

      def match_fields(event_name, req)
        fields = { event: event_name, match: req.env['rack.attack.matched'], type: req.env['rack.attack.match_type'],
                   ip: req.ip, method: req.request_method, path: req.fullpath,
                   user_agent: req.user_agent.to_s.inspect }
        fields[:params] = filtered_params(req).inspect if debug?

        fields.map { |key, value| "#{key}=#{value}" }.join(' ')
      end

      def validate_ip(ip)
        IPAddr.new(ip)
      rescue IPAddr::InvalidAddressError => e
        Rails.logger.warn "RACK ATTACK SAFELIST ERROR: #{ip.inspect} is not a valid ip/subnet, ignored: #{e.message}"
        nil
      end

      # Matched requests are hostile input: a malformed body makes Rack raise on
      # #params, and sign-in throttles would otherwise log plaintext passwords.
      def filtered_params(req)
        @param_filter ||= ActiveSupport::ParameterFilter.new(Rails.application.config.filter_parameters)
        @param_filter.filter(req.params)
      rescue Rack::Utils::ParameterTypeError, Rack::Utils::InvalidParameterError,
             Rack::QueryParser::ParamsTooDeepError => e
        { unparseable: e.class.name }
      end

      # Values are coerced: rack-attack compares counts against :limit/:maxretry
      # as-is, so a String option raises ArgumentError on every request.
      def env_to_h(env_name, default = {})
        env = ENV.fetch(env_name, nil)

        return default if env.blank?

        env.split(',')
           .to_h { _1.split(':').map(&:strip) }
           .symbolize_keys
           .transform_values(&:to_i)
      end
    end
  end
end
