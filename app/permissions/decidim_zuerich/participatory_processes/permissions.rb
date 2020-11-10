module DecidimZuerich
  module ParticipatoryProcesses
    module Permissions
      # Process admins can eprform everything *inside* that process. They cannot
      # create a process or perform actions on process groups or other
      # processes.
      def process_admin_action?
        result = super
        return result if result

        allow! if permission_action.subject == :space_private_user
      end
    end
  end
end