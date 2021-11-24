# frozen_string_literal: true

module DecidimZuerich
  module Assemblies
    module AssemblyMCell
      include ApplicationHelper

      def has_image?
        true
      end

      private

      def resource_image_path
        model.hero_image.url.presence || 'organization-default-image.png'
      end
    end
  end
end
