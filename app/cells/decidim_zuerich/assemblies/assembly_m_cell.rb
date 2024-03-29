# frozen_string_literal: true

# Override last checked at: 31.07.2023
# TODO: @cbeltrame, check for 0.27.4 upgrade

module DecidimZuerich
  module Assemblies
    # Modifications to make the /assemblies list more compact
    module AssemblyMCell
      include ApplicationHelper

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
        model.hero_image.attached? ?
            model.attached_uploader(:hero_image).path :
            asset_pack_path('media/images/organization-default-image.png')
      end

      def statuses
        []
      end

    end
  end
end
