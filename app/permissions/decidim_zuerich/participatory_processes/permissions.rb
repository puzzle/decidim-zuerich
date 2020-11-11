# frozen_string_literal: true

# Customize participatory permissions
module DecidimZuerich
  module ParticipatoryProcesses
    module Permissions
      def process_admin_action?
        result = super
        return result if result

        allow_space_private_user?
      end

      private

      def allow_space_private_user?
        return unless permission_action.subject == :space_private_user

        allowed_orgs = [1]
        current_org = context.fetch(:current_organization, nil)&.id

        allow! if allowed_orgs.include?(current_org)
      end
    end
  end
end
