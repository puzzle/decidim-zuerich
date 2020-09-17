# frozen_string_literal: true

module DecidimZuerich
  module Debates
    module CreateDebateEvent
      extend ActiveSupport::Concern

      included do
        def author_presenter
          return nil
        end
      end
    end
  end
end
