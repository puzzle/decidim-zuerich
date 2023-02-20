# frozen_string_literal: true

Decidim::System::UpdateOrganizationForm.class_eval do
  attribute :tenant_type, String
end

Decidim::System::RegisterOrganization.prepend DecidimZuerich::System::RegisterOrganization
Decidim::System::UpdateOrganization.prepend DecidimZuerich::System::UpdateOrganization
