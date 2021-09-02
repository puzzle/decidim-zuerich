# frozen_string_literal: true

module DecidimZuerich
  module Proposals
    # This helper include some methods for rendering proposals dynamic maps.
    module MapHelper
      extend ActiveSupport::Concern

      included do
        # This will remove proposals with NaN coordinates.
        def proposals_data_for_map(geocoded_proposals)
          super(geocoded_proposals.select(&:geocoded_and_valid?))
        end
      end

    end
  end
end
