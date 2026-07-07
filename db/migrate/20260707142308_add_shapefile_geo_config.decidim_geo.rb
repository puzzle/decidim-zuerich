# frozen_string_literal: true

# This migration comes from decidim_geo (originally 20260520161309)
class AddShapefileGeoConfig < ActiveRecord::Migration[7.2]
  def change
    add_reference :decidim_geo_configs, :decidim_geo_shapefiles, index: true, foreign_key: true
  end
end
