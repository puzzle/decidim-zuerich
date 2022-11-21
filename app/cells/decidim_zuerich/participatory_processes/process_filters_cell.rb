# frozen_string_literal: true

module DecidimZuerich
  module ParticipatoryProcesses
    module ProcessFiltersCell
      def other_filters_with_value
        [current_filter] + super
      end

      def title
        # Remove the title text explaining how many processes are displayed.
        # This wouldn't be accurate because we are grouping processes by process groups.
        ''
      end
    end
  end
end
