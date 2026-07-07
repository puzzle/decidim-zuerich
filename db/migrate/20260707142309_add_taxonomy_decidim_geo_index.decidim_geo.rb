# frozen_string_literal: true

# This migration comes from decidim_geo (originally 20260527085717)
class AddTaxonomyDecidimGeoIndex < ActiveRecord::Migration[7.2]
  def change
    remove_index :decidim_geo_indexes, :geo_scope_id
    remove_foreign_key :decidim_geo_indexes, :decidim_scopes
    rename_column :decidim_geo_indexes, :geo_scope_id, :geo_taxonomy_id
    add_foreign_key :decidim_geo_indexes, :decidim_taxonomies, column: :geo_taxonomy_id
    add_index :decidim_geo_indexes, :geo_taxonomy_id
  end
end
