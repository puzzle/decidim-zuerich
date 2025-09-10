# frozen_string_literal: true
# This migration comes from decidim_geo (originally 20250815091407)
class CreateGeoSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :decidim_geo_geo_settings do |t|
      t.boolean :geo_enabled, default: true, null: false
      t.belongs_to :decidim_organization, foreign_key: true

      t.timestamps
    end
  end
end
