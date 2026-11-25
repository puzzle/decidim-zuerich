# frozen_string_literal: true

# This migration came from decidim_geo but was reverted later
class ReplaceGeoEnableWithGeoModeReverted < ActiveRecord::Migration[7.0]
  def up
    return unless defined? Decidim::Geo::GeoSettings
    add_column :decidim_geo_geo_settings,
               :geo_mode,
               :string,
               default: "enabled_empty",
               null: false

    Decidim::Organization.find_each do |org|
      Decidim::Geo::GeoSettings.create!(organization: org, geo_mode: "enabled_empty") unless org.respond_to?(:geo_settings)
    end

    Decidim::Geo::GeoSettings.find_each do |geo_setting|
      geo_enabled_value = geo_setting.geo_enabled
      geo_setting.update(geo_mode: geo_enabled_value ? "enabled_empty" : "disabled")
    end

    remove_column :decidim_geo_geo_settings, :geo_enabled, :boolean
  end

  def down
    add_column :decidim_geo_geo_settings,
               :geo_enabled,
               :boolean,
               default: true,
               null: false

    Decidim::Geo::GeoSettings.find_each do |geo_setting|
      geo_enabled_value = geo_setting.geo_enabled
      geo_setting.update(geo_enabled: geo_enabled_value != "disabled")
    end

    remove_column :decidim_geo_geo_settings, :geo_mode, :string
  end
end
