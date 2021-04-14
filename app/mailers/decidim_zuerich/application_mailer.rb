# frozen_string_literal: true

module DecidimZuerich
  # Main application mailer configuration. Inherit from this to create new
  # mailers.
  module ApplicationMailer
    def set_smtp
      return if @organization.nil? || @organization.smtp_settings.blank?

      reply_to = mail.reply_to
      super
      mail.reply_to = reply_to || Decidim.config.mailer_reply
    end
  end
end
