# frozen_string_literal: true

# This migration comes from decidim_toggle (originally 20260321120000)
class CreateDecidimToggleOrganizationModuleConfigs < ActiveRecord::Migration[7.0]
  def change
    create_table :decidim_toggle_organization_module_configs do |t|
      t.belongs_to :decidim_organization,
                   null: false,
                   foreign_key: { to_table: :decidim_organizations, on_delete: :cascade },
                   index: { name: "idx_dtoggle_omc_on_org" }
      t.string :module_name, null: false
      t.jsonb :config, null: false, default: {}
      t.timestamps
    end

    add_index :decidim_toggle_organization_module_configs,
              [:decidim_organization_id, :module_name],
              unique: true,
              name: "idx_dtoggle_org_module_configs_unique"
  end
end
