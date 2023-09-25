# frozen_string_literal: true

# Override last checked at: 31.07.2023
module DecidimZuerich
  # Main application mailer configuration. Inherit from this to create new
  # mailers.
  module ApplicationMailer
    def set_smtp
      reply_to = I18n.t('decidim_zuerich.reply_to', default: "").presence
      mail.reply_to = [reply_to] if mail.reply_to.blank? && reply_to

      super
    end
  end
end
