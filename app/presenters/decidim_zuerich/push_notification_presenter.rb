# frozen_string_literal: true

### Decidim Zuerich Override
#
# Created at: 2025-07-22
# Author: Thomas Burkhalter
#
# Original:
#   Module: decidim-core
#   Class: app/presenters/decidim/push_notification_presenter.rb
#   Method: #icon
#
# Why?:
#   variant_url(:x, host: organization.host) tries to access the logo
#   from the storage at organization.host, but since we're using a different
#   domain for our S3 hosting, this fails.
#
#   We only use our code if the original code fails.
#
###

module DecidimZuerich
  module PushNotificationPresenter
    def icon
      super
    rescue
      user.organization.attached_uploader(:favicon).variant_url(:big)
    end
  end
end
