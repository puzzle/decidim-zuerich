require 'rack/attack'
require 'ipaddr'

ActiveSupport::Notifications.subscribe(/rack_attack/) do |name, start, finish, request_id, payload|
  # request object available in payload[:request]
  request = payload[:request]
  Rails.logger.warn "RACK ATTACK #{name} - #{request.ip} - #{request.url}"
end

safelist_ips = ENV.fetch('RACK_ATTACK_SAFELIST_IPS', '').split(',').map(&:strip)

safelist_ips.each do |ip_or_subnet|
  # Fails if the ip/subnet is not correct
  IPAddr.new(ip_or_subnet)

  Rack::Attack.safelist_ip(ip_or_subnet)
end
