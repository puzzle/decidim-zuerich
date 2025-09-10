# frozen_string_literal: true
# This migration comes from decidim_geo (originally 20250801053801)
class AddOrganizationToGeoModels < ActiveRecord::Migration[7.0]
  def change
    # Add the reference, accepting null values at first
    add_reference :decidim_geo_configs, :decidim_organization, null: true, index: { name: "index_decidim_geo_configs_on_organization_id" }
    add_reference :decidim_geo_indexes, :decidim_organization, null: true, index: { name: "index_decidim_geo_indexes_on_organization_id" }
    add_reference :decidim_geo_no_indexes, :decidim_organization, null: true, index: { name: "index_decidim_geo_no_indexes_on_organization_id" }
    # Update all the reference to first found organization (previous defaults)
    first_organization = Decidim::Organization.first
    if first_organization
      Decidim::Geo::GeoConfig.update_all(decidim_organization_id: first_organization.id)
      Decidim::Geo::Index.update_all(decidim_organization_id: first_organization.id)
      Decidim::Geo::NoIndex.update_all(decidim_organization_id: first_organization.id)
    end
    # Constraint references to avoid null values
    change_column_null :decidim_geo_configs, :decidim_organization_id, false
    change_column_null :decidim_geo_indexes, :decidim_organization_id, false
    change_column_null :decidim_geo_no_indexes, :decidim_organization_id, false
  end
end
