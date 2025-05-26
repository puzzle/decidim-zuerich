# frozen_string_literal: true
# This migration comes from decidim_cleaner (originally 20230106105014)

class RemoveDecidimCleaner < ActiveRecord::Migration[6.0]
  require_relative '20230202114803_add_delete_admin_logs_to_organization.decidim_cleaner'
  require_relative '20230202114804_add_delete_inactive_users_to_organization.decidim_cleaner'

  def change
    revert AddDeleteInactiveUsersToOrganization
    revert AddDeleteAdminLogsToOrganization
  end
end
