# frozen_string_literal: true

# This migration comes from decidim_geo (originally 20260515122038)
class MigrateDecidimScopeTypesToTaxonomies < ActiveRecord::Migration[7.2]
  def up
    add_reference :decidim_geo_shapefiles, :decidim_taxonomies, index: { unique: true }, foreign_key: true
    add_reference :decidim_geo_shapefile_datas, :decidim_taxonomies, index: { unique: true }, foreign_key: true, null: true
    migrate_scope_type_taxonomy
  end

  def down
    add_reference :decidim_geo_shapefiles, :decidim_scope_types, index: true, foreign_key: true
    add_reference :decidim_geo_shapefile_datas, :decidim_scopes, index: true, foreign_key: true, null: true
    rollback_scope_type_taxonomy
  end

  private

  def migrate_scope_type_taxonomy
    Decidim::Geo::Shapefile.reset_column_information

    return unless table_exists?(:decidim_scope_types) && table_exists?(:decidim_taxonomies)

    Rails.logger.debug "Starting migration of Scope Types to Taxonomies..."

    scope_types = Decidim::ScopeType.all

    return unless scope_types

    scope_types.each do |scope_type|
      taxonomy = Decidim::Taxonomy.create!(
        name: scope_type.name,
        decidim_organization_id: scope_type.organization.id,
        parent: nil,
        weight: 0
      )

      Rails.logger.debug { "Taxonomy #{taxonomy.id} created for scope_type #{scope_type.id}" }

      shapefile = Decidim::Geo::Shapefile.find_by(decidim_scope_types_id: scope_type.id)

      next unless shapefile

      shapefile.decidim_taxonomies_id = taxonomy.id
      shapefile.decidim_scope_types_id = nil
      shapefile.save!

      migrate_scope_taxonomy(scope_type, taxonomy)
    end

    Rails.logger.debug "Migration of Scope Types to Taxonomies completed."

    has_associations = Decidim::Geo::Shapefile.where.not(decidim_scope_types_id: nil).exists?

    raise ActiveRecord::ActiveRecordError, "Migration aborted: Cannot remove reference because Shapefiles are still associated with Scope Types." if has_associations

    remove_reference :decidim_geo_shapefiles, :decidim_scope_types, index: true, foreign_key: true
  end

  def migrate_scope_taxonomy(scope_type, taxonomy)
    Decidim::Geo::Shapedata.reset_column_information

    return unless table_exists?(:decidim_scopes)

    Rails.logger.debug "Starting migration of Scopes to Taxonomies..."

    scopes = Decidim::Scope.where(scope_type_id: scope_type.id)

    return unless scopes

    scopes.each do |scope|
      taxonomy_child = Decidim::Taxonomy.create!(
        name: scope.name,
        decidim_organization_id: scope.organization.id,
        parent_id: taxonomy.id,
        weight: 1
      )

      Rails.logger.debug { "Taxonomy child #{taxonomy_child.id} created for scope #{scope.id}" }

      shapedata = Decidim::Geo::Shapedata.find_by(decidim_scopes_id: scope.id)

      next unless shapedata

      shapedata.decidim_taxonomies_id = taxonomy_child.id
      shapedata.decidim_scopes_id = nil
      shapedata.save!
    end

    Rails.logger.debug "Migration of Scope to Taxonomies completed."

    has_associations = Decidim::Geo::Shapedata.where.not(decidim_scopes_id: nil).exists?

    raise ActiveRecord::ActiveRecordError, "Migration aborted: Cannot remove reference because Shapedata are still associated with Scope." if has_associations

    remove_reference :decidim_geo_shapefile_datas, :decidim_scopes, index: true, foreign_key: true, null: true
  end

  def rollback_scope_type_taxonomy
    Decidim::Geo::Shapefile.reset_column_information

    Rails.logger.debug "Rollback: Removing taxonomies created from scope_types..."

    taxonomies = Decidim::Taxonomy.all

    taxonomies.each do |taxonomy|
      next unless taxonomy.parent.nil?

      scope_type = Decidim::ScopeType.create!(name: taxonomy.name, plural: taxonomy.name, organization: taxonomy.organization)
      shapefile = Decidim::Geo::Shapefile.find_by(decidim_taxonomies_id: taxonomy.id)

      next unless shapefile

      shapefile.decidim_scope_types_id = scope_type.id
      shapefile.decidim_taxonomies_id = nil
      shapefile.save!

      rollback_scope_taxonomy(scope_type, taxonomy)
    end

    Rails.logger.debug "Rollback of Scope Types to Taxonomies completed."

    has_associations = Decidim::Geo::Shapefile.where.not(decidim_taxonomies_id: nil).exists?

    raise ActiveRecord::ActiveRecordError, "Migration aborted: Cannot remove reference because Shapefiles are still associated with Scope Types." if has_associations

    remove_reference :decidim_geo_shapefiles, :decidim_taxonomies, index: true, foreign_key: true
  end

  def rollback_scope_taxonomy(scope_type, taxonomy)
    Decidim::Geo::Shapedata.reset_column_information

    Rails.logger.debug "Rollback: Removing taxonomies created from scopes..."

    taxonomy_children = Decidim::Taxonomy.where(parent_id: taxonomy.id)

    return unless taxonomy_children

    taxonomy_children.each do |taxonomy_child|
      scope = Decidim::Scope.create!(name: taxonomy_child.name, scope_type_id: scope_type.id, decidim_organization_id: taxonomy_child.organization.id)
      shapedata = Decidim::Geo::Shapedata.find_by(decidim_taxonomies_id: taxonomy_child.id)

      next unless shapedata

      shapedata.decidim_scopes_id = scope.id
      shapedata.decidim_taxonomies_id = nil
      shapedata.save!
    end

    Rails.logger.debug "Rollback of Scopes to Taxonomies completed."

    has_associations = Decidim::Geo::Shapedata.where.not(decidim_taxonomies_id: nil).exists?

    raise ActiveRecord::ActiveRecordError, "Migration aborted: Cannot remove reference because Shapedata are still associated with Taxonomies." if has_associations

    remove_reference :decidim_geo_shapefile_datas, :decidim_taxonomies, index: true, foreign_key: true
  end
end
