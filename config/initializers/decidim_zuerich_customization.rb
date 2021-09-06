Decidim::DiffCell.include DecidimZuerich::DiffCell
Decidim::Debates::CreateDebateEvent.include DecidimZuerich::Debates::CreateDebateEvent
Decidim::Comments::CommentVotedEvent.include DecidimZuerich::Comments::CommentVotedEvent
Decidim::ParticipatoryProcesses::Permissions.prepend DecidimZuerich::ParticipatoryProcesses::Permissions
Decidim::Assemblies::AssembliesHelper.prepend DecidimZuerich::Assemblies::AssembliesHelper
Decidim::Proposals::MapHelper.prepend DecidimZuerich::Proposals::MapHelper
Decidim::ApplicationMailer.prepend DecidimZuerich::ApplicationMailer
Decidim::Proposals::DiffRenderer.prepend DecidimZuerich::Proposals::DiffRenderer

module Decidim
  module Map
    module Provider
      module DynamicMap
        autoload :Swisstopo, 'decidim/map/provider/dynamic_map/swisstopo'
      end
    end
  end
end
