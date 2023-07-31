# frozen_string_literal: true

require_relative '../../lib/customization_output'
require_relative '../../lib/decidim_zuerich/form_builder'

includes = [
  [Decidim::Debates::CreateDebateEvent,  DecidimZuerich::Debates::CreateDebateEvent],
  [Decidim::DiffCell,                    DecidimZuerich::DiffCell],
  [Decidim::FormBuilder,                 DecidimZuerich::FormBuilder]
].each { |base, addition| base.include addition }

prepends = [
  [Decidim::ApplicationMailer,                                  DecidimZuerich::ApplicationMailer],
  [Decidim::Assemblies::AssembliesHelper,                       DecidimZuerich::Assemblies::AssembliesHelper],
  [Decidim::Assemblies::AssemblyMCell,                          DecidimZuerich::Assemblies::AssemblyMCell],
  [Decidim::Forms::AnswerQuestionnaire,                         DecidimZuerich::Forms::AnswerQuestionnaire],
  [Decidim::Meetings::MeetingMCell,                             DecidimZuerich::Meetings::MeetingMCell],
  [Decidim::Meetings::MeetingPresenter,                         DecidimZuerich::Meetings::MeetingPresenter],
  [Decidim::OrganizationLogoUploader,                           DecidimZuerich::OrganizationLogoUploader],
  [Decidim::ParticipatoryProcesses::Permissions,                DecidimZuerich::ParticipatoryProcesses::Permissions],
  [Decidim::Proposals::DiffRenderer,                            DecidimZuerich::Proposals::DiffRenderer],
  [Decidim::Proposals::MapHelper,                               DecidimZuerich::Proposals::MapHelper],
  [Decidim::ParticipatoryProcesses::ProcessFiltersCell,         DecidimZuerich::ParticipatoryProcesses::ProcessFiltersCell],
  [Decidim::ResourceLocatorPresenter,                           DecidimZuerich::ResourceLocatorPresenter],
  [Decidim::ParticipatoryProcesses::ParticipatoryProcessHelper, DecidimZuerich::ParticipatoryProcesses::ParticipatoryProcessHelper]
].each { |base, addition| base.prepend addition }

override_path = Pathname.new('lib/overrides')
Rails.autoloaders.main.ignore(override_path)

overrides = override_path.glob('**/*_override.rb')
Rails.application.config.after_initialize do
  overrides.each do |override|
    require_dependency override.expand_path.to_s
  end
end

CustomizationOutput.puts_and_log(includes: includes, prepends: prepends, overrides: overrides)

# v Specially handled things (here be dragons) v

# Add the Devise custom scope to the Decidim config
# Find all instances with: <% scope = Decidim.config.devise_custom_scope.(@organization) %>
Decidim.config[:devise_custom_scope] = lambda { |org, base = nil|
  base ||= %i[decidim_zuerich devise]

  org_scope = (org.tenant_type.presence || 'other').to_sym

  # Ensure that the current tenant is using custom translations for the devise mails
  base + [org_scope] if I18n.t(org_scope, scope: base, default: nil)
}

# Setup a controller hook to setup the sms gateway before the
# request is processed. This is done through a notification to
# get access to the `current_*` environment variables within
# Decidim. Taken and adapted from the term_customizer module.
ActiveSupport::Notifications.subscribe "start_processing.action_controller" do |_name, _started, _finished, _unique_id, data|
  DecidimZuerich::Verifications::Sms::AspsmsGateway.organization = data[:headers].env["decidim.current_organization"]
end

# Override default for surveys
Decidim.find_component_manifest(:surveys).settings(:global).attributes[:clean_after_publish].default = false


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

