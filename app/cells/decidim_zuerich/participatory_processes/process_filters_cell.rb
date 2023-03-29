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

      # Replace the implementation of this method, because we don't want process groups to
      def process_count_by_filter
        return @process_count_by_filter if @process_count_by_filter

        @process_count_by_filter = %w(active upcoming past).inject({}) do |collection_by_filter, filter_name|
          filtered_processes = filtered_processes(filter_name)
          collection_by_filter.merge(filter_name => filtered_processes.count)
        end
        @process_count_by_filter["all"] = @process_count_by_filter.values.sum
        @process_count_by_filter
      end
    end
  end
end
