# frozen_string_literal: true

# Override last checked at: 31.07.2023
Decidim::Admin::OfficializationsController.class_eval do
  private

  # Add an ordering to people, to make sure pagination works correctly
  def collection
    @collection ||= current_organization.users.not_deleted.left_outer_joins(:user_moderation).order(:created_at)
  end
end
