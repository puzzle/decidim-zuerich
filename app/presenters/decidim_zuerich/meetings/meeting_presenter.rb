# frozen_string_literal: true

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