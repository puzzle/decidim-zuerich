# frozen_string_literal: true

# Override last checked at: 31.07.2023
# TODO: @cbeltrame, check for 0.27.4 upgrade

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
