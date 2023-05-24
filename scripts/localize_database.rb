#!/usr/bin/env ruby
# frozen_string_literal: true

exec('/usr/bin/env', 'rails', 'runner', $PROGRAM_NAME, *ARGV) unless defined?(Rails)

# Prepare the Database to work well locally
class DevEnv
  def self.localize_hosts
    Decidim::Organization.all.each do |org|
      old_host = org.host
      parts = old_host.split('.')
      new_host = "#{parts[..-2].join('.')}.local"

      org.host = new_host
      org.save!
      puts "Changing host '#{old_host}' to '#{new_host}'"
    end
  end

  def self.reset_password_timers
    # rubocop:disable Rails/SkipsModelValidations
    Decidim::User.update_all(password_updated_at: DateTime.now)
    # rubocop:enable Rails/SkipsModelValidations

    puts 'reseting all :password_updated_at fields'
  end
end

DevEnv.localize_hosts
DevEnv.reset_password_timers
