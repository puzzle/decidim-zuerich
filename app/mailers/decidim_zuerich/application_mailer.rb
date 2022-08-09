# frozen_string_literal: true

module DecidimZuerich
  # Main application mailer configuration. Inherit from this to create new
  # mailers.
  module ApplicationMailer
    def set_smtp
      mail.reply_to ||= I18n.t('decidim_zuerich.reply_to', default: "").presence

      super
    end
  end
end
