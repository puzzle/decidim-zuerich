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
Decidim::ParticipatoryProcesses::ProcessFiltersCell.prepend DecidimZuerich::ParticipatoryProcesses::ProcessFiltersCell
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

# Override default for surveys
Decidim.find_component_manifest(:surveys).settings(:global).attributes[:clean_after_publish].default = false

# Add the Devise custom scope to the Decidim config
# Find all instances with: <% scope = Decidim.config.devise_custom_scope.(@organization) %>
Decidim.config[:devise_custom_scope] = lambda { |org, base = nil|
  base ||= %i[decidim_zuerich devise]

  org_scope =
    case org.id
    when 1 then :mitwirken
    when 2 then :meinquartier
    else :other
    end

  # Ensure that the current tenant is using custom translations for the devise mails
  base + [org_scope] if I18n.t(org_scope, scope: base, default: nil)
}
