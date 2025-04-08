# frozen_string_literal: true

module DecidimZuerich
  # Simplifies common Rack::Attack rules
  class RackAttackHelper # rubocop:disable Metrics/ClassLength
    class << self
      def enabled?
        ENV.fetch('ENABLE_RACK_ATTACK', Rails.env.production?.to_s)
           .in?(%w[true 1])
      end

      def debug?
        ENV.fetch('RACK_ATTACK_DEBUG', 'false')
           .in?(%w[true 1])
      end

      def safelist_ips_from_env(env = 'RACK_ATTACK_SAFELIST_IPS')
        ENV.fetch(env, '')
           .split(',')
           .map(&:strip)
           .map { validate_ip(_1) }
           .compact_blank
           .each do |ip_or_subnet|
             Rack::Attack.safelist_ip(ip_or_subnet)
           end
      end

      def register_throttle_filter_from_env(name, env, **default, &block)
        options =
          { limit: 100, period: 10 }
          .merge(default)
          .merge(env_to_h(env))

        if block_given?
          Rack::Attack.throttle(name, options, &block)
        else
          Rack::Attack.throttle(name, options, &:ip)
        end
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
          request = payload[:request]
          title = "RACK ATTACK MATCH [#{name}]"
          match = "match=#{request.env['rack.attack.matched']}"
          ip = "ip=#{request.ip}"
          url = "url=#{request.url}"
          warning = "#{title}: #{match} | #{ip} | #{url}"

          Rails.logger.warn warning
        end
      end

      def subscribe_to_debug_notifications # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
        # Used for rack-attack throttling debugging
        ActiveSupport::Notifications.subscribe('rack.attack') do |_name, _start, _finish, _request_id, req|
          req = req[:request]
          # msg = [
          #   req.env['rack.attack.match_type'],
          #   req.ip,
          #   req.request_method,
          #   req.fullpath,
          #   ('"' + req.user_agent.to_s + '"')
          # ].join(' ')

          request_headers = req.headers.env
                               .except(*%w[warden HTTP_COOKIE])
                               .reject { |key| key.to_s.include?('.') }

          request_params = req.params.to_enum.to_h

          hash = {
            match_type: req.env['rack.attack.match_type'],
            request: {
              request_method: request.method,
              ip: request.ip,
              remote_ip: request.remote_ip,
              url: request.url,
              fullpath: request.fullpath,
              user_agent: request.user_agent.to_s,
              headers: request_headers,
              params: request_params
            }
          }

          msg = Hash[*hash.sort.flatten].to_json

          logger = Logger.new('log/rack-attack.log')

          if %i[throttle blocklist].include?(req.env['rack.attack.match_type'])
            logger.error(msg)
          else
            logger.info(msg)
          end
        end
      end

      private

      def validate_ip(ip)
        IPAddr.new(ip)
      rescue IPAddr::InvalidAddressError => e
        Rails.logger.warn "RACK ATTACK WHITELIST ERROR: #{ip}: Not a valid ip/subnet. Error: #{e.inspect}"
        nil
      end

      def env_to_h(env_name, default = {})
        env = ENV.fetch(env_name, nil)

        return default if env.blank?

        env.fetch(env_name, nil)
           .split(',')
           .map { _1.split(':').map(&:strip) }
           .to_h
           .symbolize_keys
      end
    end
  end
end
