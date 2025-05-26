# frozen_string_literal: true

require_relative '../../lib/decidim_zuerich/editor_link_target_helper'
require_relative '../../lib/decidim_zuerich/decidim_customization'
require_relative '../../lib/decidim_zuerich/form_builder'
require_relative '../../lib/puzzle_rails_pry_prompt'

PuzzleRailsPryPrompt.set_prompt

INCLUDES = [
  #[Decidim::Debates::CreateDebateEvent,  DecidimZuerich::Debates::CreateDebateEvent],
  [Decidim::FormBuilder,                 DecidimZuerich::FormBuilder]
].freeze

PREPENDS = [
  #[Decidim::ApplicationMailer,                                  DecidimZuerich::ApplicationMailer],
  #[Decidim::Assemblies::AssembliesHelper,                       DecidimZuerich::Assemblies::AssembliesHelper],
  #[Decidim::Assemblies::AssemblyMCell,                          DecidimZuerich::Assemblies::AssemblyMCell],
  #[Decidim::Forms::AnswerQuestionnaire,                         DecidimZuerich::Forms::AnswerQuestionnaire],
  #[Decidim::Meetings::MeetingMCell,                             DecidimZuerich::Meetings::MeetingMCell],
  #[Decidim::Meetings::MeetingPresenter,                         DecidimZuerich::Meetings::MeetingPresenter],
  #[Decidim::OrganizationLogoUploader,                           DecidimZuerich::OrganizationLogoUploader],
  #[Decidim::ParticipatoryProcesses::Permissions,                DecidimZuerich::ParticipatoryProcesses::Permissions],
  #[Decidim::Proposals::DiffRenderer,                            DecidimZuerich::Proposals::DiffRenderer],
  #[Decidim::Proposals::MapHelper,                               DecidimZuerich::Proposals::MapHelper],
  #[Decidim::ResourceLocatorPresenter,                           DecidimZuerich::ResourceLocatorPresenter],
  #[Decidim::ParticipatoryProcesses::ParticipatoryProcessHelper, DecidimZuerich::ParticipatoryProcesses::ParticipatoryProcessHelper],
  #[Decidim::System::RegisterOrganization,                       DecidimZuerich::System::RegisterOrganization],
  #[Decidim::System::UpdateOrganization,                         DecidimZuerich::System::UpdateOrganization]
].freeze

OVERRIDES = ['app/overrides'].freeze

DecidimZuerich::DecidimCustomization.log_and_load(includes: INCLUDES, prepends: PREPENDS, overrides: OVERRIDES)

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
ActiveSupport::Notifications.subscribe 'start_processing.action_controller' do |_name, _started, _finished, _unique_id, data|
  DecidimZuerich::Verifications::Sms::AspsmsGateway.organization = data[:headers].env['decidim.current_organization']
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

class Object
  def current_assembly
    @current_assembly ||= begin
      model = organization_assemblies if defined?(organization_assemblies)
      model ||= Decidim::Assembly

      model.find_by!(
        slug: params[:assembly_slug] || params[:slug]
      )
    end
  end
end
