# frozen_string_literal: true

require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/object/blank'
require_relative '../../../lib/decidim_zuerich/rack_attack'

RSpec.describe DecidimZuerich::RackAttack do
  describe 'env option parsing' do
    around do |example|
      ENV['RACK_ATTACK_SPEC_FILTER'] = 'maxretry:5, findtime:600, bantime:3600'
      example.run
      ENV.delete('RACK_ATTACK_SPEC_FILTER')
    end

    # rack-attack does `count >= maxretry` / `count > limit` without coercion,
    # so String values raise ArgumentError on every request that hits the filter.
    it 'yields Integers' do
      expect(described_class.send(:env_to_h, 'RACK_ATTACK_SPEC_FILTER'))
        .to eq(maxretry: 5, findtime: 600, bantime: 3600)
    end
  end
end
