# frozen_string_literal: true

# Override last checked at: 31.07.2023
# TODO: @cbeltrame, check for 0.27.4 upgrade

module DecidimZuerich
  module Meetings
    # Modifications to make the /meetings list more compact
    module MeetingMCell
      include ApplicationHelper

      def has_authors?
        false
      end

      def title
        present(model).title
      end

      private

      def resource_image_path
        present(model).image_path.presence || asset_pack_path('media/images/organization-default-image.png')
      end

      def followers_count
        if model.respond_to?(:followers_count)
          model.followers_count
        else
          model.followers.count
        end
      end

      def description
        nil
      end

      def statuses
        []
      end

      def has_actions?
        false
      end

      def has_badge?
        false
      end

      def show_footer_actions?
        false
      end
    end
  end
end