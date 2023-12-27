require 'rack/attack'
require 'ipaddr'

Rack::Attack.enabled = ENV.fetch('ENABLE_RACK_ATTACK', Rails.env.production?.to_s).in?(%w[true 1])

safelist_ips = ENV.fetch('RACK_ATTACK_SAFELIST_IPS', '').split(',').map(&:strip)

safelist_ips.each do |ip_or_subnet|
  # Fails if the ip/subnet is not correct
  IPAddr.new(ip_or_subnet)

  Rack::Attack.safelist_ip(ip_or_subnet)
end

ActiveSupport::Notifications.subscribe(/rack_attack/) do |name, start, finish, request_id, payload|
  # request object available in payload[:request]
  request = payload[:request]
  Rails.logger.warn "RACK ATTACK #{name} - #{request.ip} - #{request.url}"
end

ActiveSupport::Notifications.subscribe('rack.attack') do |_name, _start, _finish, _request_id, req|
  req = req[:request]
  # msg = [req.env['rack.attack.match_type'], req.ip, req.request_method, req.fullpath, ('"' + req.user_agent.to_s + '"')].join(' ')
  hash = {
    match_type: req.env['rack.attack.match_type'],
    request: {
      request_method: req.request_method,
      ip: req.ip,
      remote_ip: req.remote_ip,
      url: req.url,
      fullpath: req.fullpath,
      user_agent: ('"' + req.user_agent.to_s + '"'),
      headers: req.headers.env.reject { |key| key.to_s.include?('.') },
      params: req[:params].to_enum.to_h
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