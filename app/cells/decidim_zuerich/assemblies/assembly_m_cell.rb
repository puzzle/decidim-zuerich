# frozen_string_literal: true

module DecidimZuerich
  module Assemblies
    # Modifications to make the /assemblies list more compact
    module AssemblyMCell
      include ApplicationHelper

      def has_image?
        true
      end

      def followers_count
        if model.respond_to?(:followers_count)
          model.followers_count
        else
          model.followers.count
        end
      end

      def has_badge?
        false
      end

      def description
        nil
      end

      private

      def resource_image_path
        model.hero_image.url.presence || 'organization-default-image.png'
      end

      def statuses
        []
      end

    end
  end
end
