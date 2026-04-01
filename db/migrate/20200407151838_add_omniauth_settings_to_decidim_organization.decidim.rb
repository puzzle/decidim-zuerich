# frozen_string_literal: true

# This migration comes from decidim (originally 20191113092826)
# This file has been modified by `decidim upgrade:migrations` task on 2026-03-31 11:42:00 UTC
class AddOmniauthSettingsToDecidimOrganization < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_organizations, :omniauth_settings, :jsonb
  end
end
