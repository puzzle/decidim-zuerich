# frozen_string_literal: true

# Override last checked at: 10.04.2025
LINK_TARGET_FIELDS = %i[announcement_de announcement_en].freeze

Decidim::Admin::ComponentsController.class_eval do # rubocop:disable Metrics
  def edit # rubocop:disable Metrics
    @component = query_scope.find(params[:id])
    enforce_permission_to :update, :component, component: @component

    @form = form(@component.form_class).from_model(@component)

    handle_target_tag = proc { |hash|
      DecidimZuerich::EditorLinkTargetHelper.handle_target_tag(hash, LINK_TARGET_FIELDS)
    }

    @form[:settings] = handle_target_tag.call(@form[:settings])
    @form[:default_step_settings] = handle_target_tag.call(@form[:default_step_settings])

    return unless @form[:step_settings]

    @form[:step_settings].each do |key, _value|
      @form[:step_settings][key] = handle_target_tag.call(@form[:step_settings][key])
    end
  end

  private

  def component_params # rubocop:disable Metrics
    new_settings = proc do |name, data|
      Decidim::Component
        .build_settings(manifest, name, data, current_organization)
        .then do |settings|
          DecidimZuerich::EditorLinkTargetHelper.handle_query_parameter(settings, LINK_TARGET_FIELDS)
        end
    end

    params[:component].permit!.tap do |hsh|
      hsh[:id] = params[:id]
      hsh[:manifest] = manifest
      hsh[:participatory_space] = current_participatory_space
      hsh[:settings] = new_settings.call(:global, hsh[:settings])
      if hsh[:default_step_settings]
        hsh[:default_step_settings] = new_settings.call(:step, hsh[:default_step_settings])
      else
        hsh[:step_settings] ||= {}
        hsh[:step_settings].each do |key, value|
          hsh[:step_settings][key] = new_settings.call(:step, value)
        end
      end
    end
  end
end
