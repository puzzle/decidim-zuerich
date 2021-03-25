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
    end
  end
end
