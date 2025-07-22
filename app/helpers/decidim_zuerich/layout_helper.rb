# frozen_string_literal: true

###
#
# Created at: 2025-07-22
# Author: Thomas Burkhalter
#
# What?:
#   This is a prepend for Decidim::LayoutHelper that overrides #favicon/#apple_favicon/#legacy_favicon
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
  module LayoutHelper
    def favicon
      super
    rescue ArgumentError
      safe_join(Decidim::OrganizationFaviconUploader::SIZES.map do |version, size|
        favicon_link_tag(current_organization.attached_uploader(:favicon).variant_url(version), sizes: "#{size}x#{size}")
      end)
    end

    def apple_favicon
      super
    rescue ArgumentError
      icon_image = current_organization.attached_uploader(:favicon).variant_url(:medium)
      return unless icon_image

      favicon_link_tag(icon_image, rel: "apple-touch-icon", type: "image/png")
    end

    def legacy_favicon
      super
    rescue ArgumentError
      variant = :favicon if current_organization.favicon.content_type != "image/vnd.microsoft.icon"
      icon_image = current_organization.attached_uploader(:favicon).variant_url(variant)
      return unless icon_image

      favicon_link_tag(icon_image, rel: "icon", sizes: "any", type: nil)
    end
  end
end
