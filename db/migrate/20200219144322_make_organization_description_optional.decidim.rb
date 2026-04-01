# frozen_string_literal: true

# This migration comes from decidim (originally 20161209134715)
# This file has been modified by `decidim upgrade:migrations` task on 2026-03-31 11:41:59 UTC
class MakeOrganizationDescriptionOptional < ActiveRecord::Migration[5.0]
  def change
    change_column :decidim_organizations, :welcome_text, :jsonb, null: true
  end
end
