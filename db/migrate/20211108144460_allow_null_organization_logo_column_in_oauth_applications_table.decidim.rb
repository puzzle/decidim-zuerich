# frozen_string_literal: true

# This migration comes from decidim (originally 20210407190753)
# This file has been modified by `decidim upgrade:migrations` task on 2026-03-31 11:42:00 UTC
class AllowNullOrganizationLogoColumnInOAuthApplicationsTable < ActiveRecord::Migration[6.0]
  def change
    change_column_null :oauth_applications, :organization_logo, true
  end
end
