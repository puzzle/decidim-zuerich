# frozen_string_literal: true

# This migration comes from decidim_conferences (originally 20200320105913)
# This file has been modified by `decidim upgrade:migrations` task on 2026-03-31 11:41:59 UTC
class IndexForeignKeysInDecidimConferences < ActiveRecord::Migration[5.2]
  def change
    add_index :decidim_conferences, :decidim_scope_id
  end
end
