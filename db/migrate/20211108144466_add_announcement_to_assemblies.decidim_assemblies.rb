# frozen_string_literal: true

# This migration comes from decidim_assemblies (originally 20210507063604)
# This file has been modified by `decidim upgrade:migrations` task on 2026-03-31 11:41:59 UTC
class AddAnnouncementToAssemblies < ActiveRecord::Migration[6.0]
  def change
    add_column :decidim_assemblies, :announcement, :jsonb
  end
end
