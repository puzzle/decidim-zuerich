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

# Setup a controller hook to setup the sms gateway before the
# request is processed. This is done through a notification to
# get access to the `current_*` environment variables within
# Decidim. Taken and adapted from the term_customizer module.
ActiveSupport::Notifications.subscribe "start_processing.action_controller" do |_name, _started, _finished, _unique_id, data|
  DecidimZuerich::Verifications::Sms::AspsmsGateway.organization = data[:headers].env["decidim.current_organization"]
end
