# frozen_string_literal: true

Decidim::ApplicationMailer.class_eval do
  def set_from
    return if organization.nil?

    opts = { scope: 'decidim_zuerich.reply_to', default: '' }
    tenant_type = organization.tenant_type.presence

    reply_to = I18n.t(tenant_type, **opts).presence if tenant_type
    reply_to ||= I18n.t(:default, **opts).presence

    mail.reply_to = reply_to && [reply_to]

    return if already_defined_name_in_mail?(mail.from.first)

    mail.from = sender
  end
end
