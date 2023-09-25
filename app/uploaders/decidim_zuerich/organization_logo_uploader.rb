# frozen_string_literal: true

# Override last checked at: 31.07.2023
# TODO: @cbeltrame, check for 0.27.4 upgrade

module DecidimZuerich
  # Additionally allow SVG as organization logo format
  module OrganizationLogoUploader
    def content_type_allowlist
      %w(image/jpeg image/png image/svg+xml)
    end

    def extension_allowlist
      %w(jpeg jpg png svg)
    end
  end
end