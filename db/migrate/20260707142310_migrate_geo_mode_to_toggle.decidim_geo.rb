# frozen_string_literal: true

# This migration comes from decidim_geo (originally 20260618120000)
class MigrateGeoModeToToggle < ActiveRecord::Migration[7.0]
  class GeoSettings < ApplicationRecord
    self.table_name = "decidim_geo_geo_settings"

    belongs_to :organization,
               class_name: "Decidim::Organization",
               foreign_key: :decidim_organization_id,
               optional: true
  end

  def up
    return unless table_exists?(:decidim_geo_geo_settings)

    GeoSettings.find_each do |geo_setting|
      organization = geo_setting.organization
      next unless organization

      enabled = geo_setting.geo_mode != "disabled"
      Decidim::Toggle.save_config!(
        organization,
        :decidim_geo,
        { "enabled" => enabled, "search_bar" => enabled }
      )
    end

    org_ids_with_settings = GeoSettings.pluck(:decidim_organization_id)
    Decidim::Organization.where.not(id: org_ids_with_settings).find_each do |organization|
      Decidim::Toggle.save_config!(
        organization,
        :decidim_geo,
        { "enabled" => false, "search_bar" => false }
      )
    end

    drop_table :decidim_geo_geo_settings
  end

  def down
    create_table :decidim_geo_geo_settings do |t|
      t.references :decidim_organization,
                   null: false,
                   foreign_key: { to_table: :decidim_organizations },
                   index: { unique: true }
      t.string :geo_mode, default: "disabled", null: false
      t.timestamps
    end

    Decidim::Organization.find_each do |organization|
      config = Decidim::Toggle.config_for(organization, :decidim_geo)
      geo_mode = config[:enabled] ? "enabled_empty" : "disabled"
      GeoSettings.create!(decidim_organization_id: organization.id, geo_mode:)
    end
  end
end
