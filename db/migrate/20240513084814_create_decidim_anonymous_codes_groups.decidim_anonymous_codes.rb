# frozen_string_literal: true
# This migration comes from decidim_anonymous_codes (originally 20240403091336)

class CreateDecidimAnonymousCodesGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :decidim_anonymous_codes_groups do |t|
      t.jsonb :title

      t.datetime :expires_at
      t.boolean :active, default: true, null: false
      t.integer :max_reuses, default: 1, null: false
      t.integer :tokens_count, default: 0, null: false
      t.references :resource, polymorphic: true, null: true, index: { name: "decidim_anonymous_codes_groups_on_resource" }
      t.references :decidim_organization, null: false, foreign_key: true, index: { name: "decidim_anonymous_codes_groups_on_organization" }

      t.timestamps
    end
  end
end
