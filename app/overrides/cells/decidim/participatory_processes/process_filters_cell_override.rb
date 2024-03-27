# frozen_string_literal: true

# We would love to do a prepend instead of what is happening here
# For whatever reason though the prepend never properly works
# Even if we include the module it doesn't get loaded
# Must be some crazy loading shenanigans
# Pry-ing into the customization class and using the following commands might be useful for future debugging:
# $ -a Decidim::ParticipatoryProcesses::ProcessFiltersCell
# $ -a DecidimZuerich::ParticipatoryProcesses::ProcessFiltersCell
Decidim::ParticipatoryProcesses::ProcessFiltersCell.class_eval do
  def other_filters_with_value
    @other_filters_with_value ||= [current_filter] + other_filters.select do |filter|
      process_count_by_filter[filter].positive?
    end
  end
end