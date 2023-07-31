# frozen_string_literal: true

# Override last checked at: 31.07.2023
module DecidimZuerich
  module System
    module RegisterOrganization
      def create_organization
        super.update!(tenant_type: form.tenant_type)
      end
    end
  end
end
