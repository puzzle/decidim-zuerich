# frozen_string_literal: true

# Override last checked at: 16.03.2026
Decidim::Proposals::ProposalsController.class_eval do
  private

  def default_view_mode
    @default_view_mode ||= begin
      current_component.settings.default_view_mode != "automatic" ?
        current_component.settings.default_view_mode :
        # Original Decidim behaviour follows here:
        current_component.settings.attachments_allowed? ? "grid" : "list"
    end
  end
end
