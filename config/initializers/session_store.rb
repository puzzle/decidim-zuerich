# frozen_string_literal: true

# Be sure to restart your server when you modify this file.
# require 'action_dispatch/middleware/session/dalli_store'

Rails.application.config.session_store(
  ActionDispatch::Session::CacheStore,
  memcache_server: ['127.0.0.1'],
  namespace: 'sessions',
  key: '_session',
  expire_after: 4.hours,
  secure: true,
  same_site: :lax
)

def cache_reachable?
  Rails.cache.stats.values.any?
end

def memcache_configured?
  if Rails.env.production?
    ENV['RAILS_MEMCACHED_HOST'].present?
  else
    Rails.env.development?
  end
end

def skip_memcache_check
  ENV['SKIP_MEMCACHE_CHECK'].present?
end


# We expect memcache to work in production.
# Prevents an error with the rails console on OpenShift
if !skip_memcache_check &&
   memcache_configured? &&
   !Rails.env.production? &&
   !cache_reachable?
  raise 'As CSRF tokens are read from cache, we require a memcache instance to start'
end
