#!/usr/bin/env ruby
# frozen_string_literal: true

exec('/usr/bin/env', 'rails', 'runner', $PROGRAM_NAME, *ARGV) unless defined?(Rails)

# Prepare the Database to work well locally
class DevEnv

  def self.run
    new.run
  end

  def run
    puts "\n\n"
    localize_hosts
    reset_password_timers
    remove_mail_settings
  end

  def localize_hosts
    Decidim::Organization.all.each do |org|
      old_host = org.host
      parts = old_host.split('.')
      new_host = "#{parts[..-2].join('.')}.local"

      org.host = new_host
      org.save!
      puts "Changing host '#{old_host}' to '#{new_host}'"
    end
  end

  def reset_password_timers
    # rubocop:disable Rails/SkipsModelValidations
    Decidim::User.update_all(password_updated_at: DateTime.now)
    # rubocop:enable Rails/SkipsModelValidations

    puts 'reseting all :password_updated_at fields'
  end

  # This is needed so tools like mailcatcher work
  def remove_mail_settings(smtp_settings=nil)
    smtp_settings ||= {}
    Decidim::Organization.update_all(smtp_settings: smtp_settings)

    puts 'reseting all :smtp_settings fields'
  end
end

DevEnv.run
