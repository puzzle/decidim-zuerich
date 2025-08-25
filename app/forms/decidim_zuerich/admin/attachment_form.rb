# frozen_string_literal: true

### Decidim Zuerich Override
#
# Created at: 2025-08-25
# Author: Thomas Burkhalter
#
# Original:
#   Module: decidim-admin
#   Class: app/forms/decidim/admin/attachment_form.rb
#
# Why?:
#   The validation for the `link` field checks for a valid url
#   even if a file is uploaded instead.
#
#   Original Code:
#   ```ruby
#   validates :link, url: true, if: -> { link.present? }
#   ```
#
###

module DecidimZuerich
  module Admin
    module AttachmentForm
      extend ActiveSupport::Concern

      included do
        _validators[:link] = []

        link_callbacks = _validate_callbacks.select do |callback|
          callback.filter.attributes.include?(:link)
        end

        link_callbacks.each do |callback|
          _validate_callbacks.delete(callback)
        end

        validates :link, url: true, if: -> { link.present? }
      end
    end
  end
end
