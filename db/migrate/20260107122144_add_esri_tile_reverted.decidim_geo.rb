# frozen_string_literal: true
# This migration came from decidim_geo but was reverted later
class AddEsriTileReverted < ActiveRecord::Migration[7.0]
  def change
    add_column :decidim_geo_configs, :esri_tile_enabled, :boolean, default: false, null: false
  end
end
