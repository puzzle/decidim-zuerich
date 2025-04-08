# frozen_string_literal: true

require 'rack/attack'
require 'ipaddr'
require_relative '../../lib/rack_attack_helper'

rack = DecidimZuerich::RackAttackHelper

Rack::Attack.enabled = rack.enabled?
rack.safelist_ips_from_env
rack.register_s3_redirects
rack.register_throttle_filter_from_env 'requests by ip', 'RACK_ATTACK_FILTER_BY_IP'
rack.register_allow2ban_filter_from_env 'secure admin logins', 'RACK_ATTACK_FILTER_ADMIN_LOGIN' do |req|
  req.post? && req.path.include?('system')
end

rack.subscribe_to_notifications
rack.subscribe_to_debug_notifications if rack.debug?
