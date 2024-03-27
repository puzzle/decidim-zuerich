require 'rack/attack'
require 'ipaddr'

# Rack::Attack.enabled = ENV.fetch('ENABLE_RACK_ATTACK', Rails.env.production?.to_s).in?(%w[true 1])
Rack::Attack.enabled = true

safelist_ips = ENV.fetch('RACK_ATTACK_SAFELIST_IPS', '').split(',').map(&:strip)

safelist_ips.each do |ip_or_subnet|
  # Fails if the ip/subnet is not correct
  IPAddr.new(ip_or_subnet)

  Rack::Attack.safelist_ip(ip_or_subnet)
end

Rack::Attack.throttle('requests by ip', limit: 100, period: 10, &:ip)

Rack::Attack.blocklist('secure admin logins') do |req|
  Rack::Attack::Allow2Ban.filter(req.ip, maxretry: 5, findtime: 10.minutes, bantime: 1.hour) do
    req.post? && req.path.include?('system')
  end
end

ActiveSupport::Notifications.subscribe(/rack_attack/) do |name, _start, _finish, _request_id, payload|
  # request object available in payload[:request]
  request = payload[:request]
  # require 'pry'; binding.pry
  Rails.logger.warn "RACK ATTACK MATCH: #{name}: #{request.env['rack.attack.matched']} | ip: #{request.ip} | url: #{request.url}"
end

# Used for rack-attack throttling debugging
# # rubocop:disable Metrics/BlockLength
# ActiveSupport::Notifications.subscribe('rack.attack') do |_name, _start, _finish, _request_id, req|
#   req = req[:request]
#   # msg = [
#   #   req.env['rack.attack.match_type'],
#   #   req.ip,
#   #   req.request_method,
#   #   req.fullpath,
#   #   ('"' + req.user_agent.to_s + '"')
#   # ].join(' ')

#   request_headers =
#     req
#     .headers
#     .env
#     .except(*%w[warden HTTP_COOKIE]
#     .reject { |key| key.to_s.include?('.') }

#   request_params = req.params.to_enum.to_h

#   hash = {
#     match_type: req.env['rack.attack.match_type'],
#     request: {
#       request_method: request.method,
#       ip: request.ip,
#       remote_ip: request.remote_ip,
#       url: request.url,
#       fullpath: request.fullpath,
#       user_agent: request.user_agent.to_s,
#       headers: request_headers,
#       params: request_params
#     }
#   }

#   msg = Hash[*hash.sort.flatten].to_json

#   logger = Logger.new('log/rack-attack.log')

#   if %i[throttle blocklist].include?(req.env['rack.attack.match_type'])
#     logger.error(msg)
#   else
#     logger.info(msg)
#   end
#   # rubocop:enable Metrics/BlockLength
# end
