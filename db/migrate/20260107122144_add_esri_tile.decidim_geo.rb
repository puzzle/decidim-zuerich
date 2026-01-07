# frozen_string_literal: true
# This migration comes from decidim_geo (originally 20251211103145)
class AddEsriTile < ActiveRecord::Migration[7.0]
  def change
    add_column :decidim_geo_configs, :esri_tile_enabled, :boolean, default: false, null: false
  end
end
