# frozen_string_literal: true

###
#
# Created at: 2025-07-22
# Author: Thomas Burkhalter
#
# What?:
#   This is a prepend for Decidim::PushNotificationMessage that overrides #icon
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
  module PushNotificationMessage
    def icon
      super
    rescue ArgumentError
      organization.attached_uploader(:favicon).variant_url(:big)
    end
  end
end
