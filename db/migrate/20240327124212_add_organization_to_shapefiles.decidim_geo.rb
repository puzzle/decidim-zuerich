# This migration comes from decidim_geo (originally 20240309004347)
class AddOrganizationToShapefiles < ActiveRecord::Migration[6.1]
  def change
    add_reference :decidim_geo_shapefiles, :decidim_organization, foreign_key: true, null: true
    remove_column :decidim_geo_shapefiles, :shapefile
  end
end
