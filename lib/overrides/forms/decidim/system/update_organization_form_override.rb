# frozen_string_literal: true

# Override last checked at: 31.07.2023
Decidim::System::UpdateOrganizationForm.class_eval do
  attribute :tenant_type, String
end