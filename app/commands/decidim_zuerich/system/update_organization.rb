# frozen_string_literal: true

module DecidimZuerich
  module System
    module UpdateOrganization
      def save_organization
        organization.tenant_type = form.tenant_type
        super
      end
    end
  end
end
