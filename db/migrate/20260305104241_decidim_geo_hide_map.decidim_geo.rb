# frozen_string_literal: true

# This migration comes from decidim_geo (originally 20260203145259)
class DecidimGeoHideMap < ActiveRecord::Migration[7.0]
  def change
    create_table :decidim_geo_hide_map do |t|
      t.boolean :hide_map, default: false, null: false
      t.integer :decidim_component_id
      t.string :decidim_component_type
      t.belongs_to :decidim_organization, foreign_key: true

      t.index [:decidim_component_type, :decidim_component_id], unique: true, name: "decidim_geo_hide_map_component"

      t.timestamps
    end
    create_attr_entry
  end

  def create_attr_entry
    Decidim::Component.find_each do |component|
      unless component.attribute_present?(:decidim_geo_hide_map)
        hide_map_component = Decidim::Geo::HideMap.new
        hide_map_component.decidim_organization_id = component.organization.id
        hide_map_component.decidim_component_id = component.id
        hide_map_component.decidim_component_type = component.class.name
        hide_map_component.hide_map = false
        component.decidim_geo_hide_map = hide_map_component

        component.save
      end
    end
  end
end
