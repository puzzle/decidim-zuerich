# frozen_string_literal: true

# Override last checked at: 31.07.2023
# TODO: @cbeltrame, check for 0.27.4 upgrade

module DecidimZuerich
  module Meetings
    module MeetingPresenter
      def image_path
        return nil unless meeting

        Nokogiri::HTML
            .parse(translated_attribute meeting.description)
            .css('img')
            .first
            &.attr('src')
      end
    end
  end
end