# frozen_string_literal: true

# This migration comes from decidim_sortitions (originally 20180102101128)
# This file has been modified by `decidim upgrade:migrations` task on 2026-03-31 11:42:00 UTC
class AddReferenceToSortitions < ActiveRecord::Migration[5.1]
  def change
    add_column :decidim_module_sortitions_sortitions, :reference, :string
    change_column_null :decidim_module_sortitions_sortitions, :reference, false
  end
end
