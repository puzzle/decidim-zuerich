# frozen_string_literal: true

# This migration comes from decidim_participatory_processes (originally 20170221094835)
# This file has been modified by `decidim upgrade:migrations` task on 2026-03-31 11:42:00 UTC
class AddScopesToProcesses < ActiveRecord::Migration[5.0]
  def change
    rename_column :decidim_participatory_processes, :scope, :meta_scope
    add_column :decidim_participatory_processes, :decidim_scope_id, :integer
  end
end
