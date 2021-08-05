# frozen_string_literal: true

require "active_support/concern"

module DecidimZuerich
  module Proposals
    module ProposalsController
      extend ActiveSupport::Concern

      included do
        def default_filter_params
          {
            search_text: "",
            origin: default_filter_origin_params,
            activity: "all",
            category_id: default_filter_category_params,
            state: %w(accepted evaluating state_not_published),
            scope_id: default_filter_scope_params,
            related_to: "",
            type: "proposals"
          }
        end
      end

    end
  end
end
