# frozen_string_literal: true

# This migration comes from decidim (originally 20190220023422)
# This file has been modified by `decidim upgrade:migrations` task on 2026-03-31 11:42:00 UTC
class AddColorsToDecidimOrganization < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_organizations, :colors, :jsonb, default: {}
  end
end
