# frozen_string_literal: true

require_relative '../../lib/decidim_zuerich/editor_link_target_helper'
require_relative '../../lib/decidim_zuerich/decidim_customization'
require_relative '../../lib/decidim_zuerich/form_builder'
require_relative '../../lib/decidim_zuerich/upgrade/wysiwyg_migrator'
require_relative '../../lib/puzzle_rails_pry_prompt'

# rubocop:disable Metrics/BlockLength, Lint/ConstantDefinitionInBlock

Rails.application.config.to_prepare do
  PuzzleRailsPryPrompt.set_prompt

  INCLUDES = [
    # [Decidim::Debates::CreateDebateEvent,      DecidimZuerich::Debates::CreateDebateEvent],
    [Decidim::FormBuilder,                       DecidimZuerich::FormBuilder],
    [Decidim::Forms::Admin::UpdateQuestionnaire, DecidimZuerich::Forms::Admin::UpdateQuestionnaire],
    [Decidim::Admin::AttachmentForm,             DecidimZuerich::Admin::AttachmentForm]
  ].freeze

  PREPENDS = [
    # [Decidim::ApplicationMailer,                   DecidimZuerich::ApplicationMailer],
    # [Decidim::ParticipatoryProcesses::Permissions, DecidimZuerich::ParticipatoryProcesses::Permissions],
    # [Decidim::Proposals::MapHelper,                DecidimZuerich::Proposals::MapHelper],
    # [Decidim::System::RegisterOrganization,        DecidimZuerich::System::RegisterOrganization],
    # [Decidim::System::UpdateOrganization,          DecidimZuerich::System::UpdateOrganization],
    [Decidim::Upgrade::WysiwygMigrator,              DecidimZuerich::Upgrade::WysiwygMigrator],
    [Decidim::PushNotificationMessage,               DecidimZuerich::PushNotificationMessage],
    [Decidim::PushNotificationPresenter,             DecidimZuerich::PushNotificationPresenter],
    [Decidim::LayoutHelper,                          DecidimZuerich::LayoutHelper],
    [Decidim::Surveys::SurveyConfirmationMailer,     DecidimZuerich::Surveys::SurveyConfirmationMailer]
  ].freeze

  OVERRIDES = [
    'app/overrides'
  ].freeze

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
  ActiveSupport::Notifications.subscribe 'start_processing.action_controller' do |_, _, _, _, data|
    DecidimZuerich::Verifications::Sms::AspsmsGateway.organization = data[:headers].env['decidim.current_organization']
  end

  # Override default for surveys
  Decidim.find_component_manifest(:surveys).settings(:global).attributes[:clean_after_publish]&.default = false

  # Add a setting for default_view_mode to proposals components
  Decidim.find_component_manifest(:proposals).settings(:global).attribute :default_view_mode, type: :select, default: "automatic", choices: -> { %w(automatic grid list).freeze }

  module Decidim
    module Map
      module Provider
        # nodoc
        module DynamicMap
          autoload :Swisstopo, 'decidim/map/provider/dynamic_map/swisstopo'
          autoload :GisZh, 'decidim/map/provider/dynamic_map/gis_zh'
        end
      end
    end
  end

  # nodoc
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

  ActiveSupport::Notifications.subscribe('decidim.forms.answer_questionnaire:after') do |event_name, data|
    Rails.logger.info "#{event_name} Received!"
    questionnaire = data[:resource]
    has_component = questionnaire.questionnaire_for.respond_to? :component
    next unless has_component

    component = questionnaire.questionnaire_for.component
    next unless component.manifest_name == 'surveys'

    email = component.try(:settings).try(:notified_email)
    id = data[:extra][:session_token]

    DecidimZuerich::Surveys::SurveyAnsweredMailer.answered(email, component, id).deliver_now if email.present?
  end

  # Decidim Zuerich Override
  #
  # Created at: 2026-02-16
  # Author: Thomas Burkhalter
  #
  # Original: Not applicable
  #
  # Why?:
  #   On User creation, set a default close_meeting_reminder setting,
  #   that does not spam everyone
  ActiveSupport::Notifications.subscribe(/sql.active_record/) do |event|
    user =
      case event.payload[:name]
      when 'Decidim::User Create'
        event.payload[:binds]
             .select { %w[email decidim_organization_id].include?(_1.name) }
             .to_h { [_1.name, _1.value] }
             .merge({ admin: true })
             .then { Decidim::User.find_by(_1) }
      when /Decidim::.*UserRole Create/
        data = event.payload[:binds].to_h { [_1.name.to_sym, _1.value] }

        Decidim::User.find(data[:decidim_user_id]) if data[:role] == 'admin'
      end

    next unless user

    Rails.logger.info "#{event.payload[:name]} Received! Updating default close_meeting_reminder"

    user.notification_settings['close_meeting_reminder'] ||= '0'
    user.save! if user.changed?
  end
end

# rubocop:enable Metrics/BlockLength, Lint/ConstantDefinitionInBlock
