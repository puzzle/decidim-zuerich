# frozen_string_literal: true

# This migration comes from decidim (originally 20170913092351)
# This file has been modified by `decidim upgrade:migrations` task on 2026-03-31 11:41:59 UTC
class AddHeaderSnippetsToOrganizations < ActiveRecord::Migration[5.1]
  def change
    add_column :decidim_organizations, :header_snippets, :text
  end
end
