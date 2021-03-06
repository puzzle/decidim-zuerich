Decidim::DiffCell.include DecidimZuerich::DiffCell
Decidim::Debates::CreateDebateEvent.include DecidimZuerich::Debates::CreateDebateEvent
Decidim::ParticipatoryProcesses::Permissions.prepend DecidimZuerich::ParticipatoryProcesses::Permissions

module Decidim
  module Map
    module Provider
      module DynamicMap
        autoload :Swisstopo, "decidim/map/provider/dynamic_map/swisstopo"
      end
    end
  end
end