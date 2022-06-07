Decidim::ApplicationMailer.prepend DecidimZuerich::ApplicationMailer
Decidim::Assemblies::AssembliesHelper.prepend DecidimZuerich::Assemblies::AssembliesHelper
Decidim::Assemblies::AssemblyMCell.prepend DecidimZuerich::Assemblies::AssemblyMCell
Decidim::Comments::CommentVotedEvent.include DecidimZuerich::Comments::CommentVotedEvent
Decidim::Debates::CreateDebateEvent.include DecidimZuerich::Debates::CreateDebateEvent
Decidim::DiffCell.include DecidimZuerich::DiffCell
Decidim::Forms::AnswerQuestionnaire.prepend DecidimZuerich::Forms::AnswerQuestionnaire
Decidim::Meetings::MeetingMCell.prepend DecidimZuerich::Meetings::MeetingMCell
Decidim::Meetings::MeetingPresenter.prepend DecidimZuerich::Meetings::MeetingPresenter
Decidim::OrganizationLogoUploader.prepend DecidimZuerich::OrganizationLogoUploader
Decidim::ParticipatoryProcesses::Permissions.prepend DecidimZuerich::ParticipatoryProcesses::Permissions
Decidim::Proposals::DiffRenderer.prepend DecidimZuerich::Proposals::DiffRenderer
Decidim::Proposals::MapHelper.prepend DecidimZuerich::Proposals::MapHelper
Decidim::ResourceLocatorPresenter.prepend DecidimZuerich::ResourceLocatorPresenter
Decidim::ParticipatoryProcesses::ParticipatoryProcessHelper.prepend DecidimZuerich::ParticipatoryProcesses::ParticipatoryProcessHelper

module Decidim
  module Map
    module Provider
      module DynamicMap
        autoload :Swisstopo, 'decidim/map/provider/dynamic_map/swisstopo'
        autoload :GisZh, 'decidim/map/provider/dynamic_map/gis_zh'
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
