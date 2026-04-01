# frozen_string_literal: true

# This migration comes from decidim_participatory_processes (originally 20171215081244)
# This file has been modified by `decidim upgrade:migrations` task on 2026-03-31 11:42:00 UTC
class AddWeightToAttachments < ActiveRecord::Migration[5.1]
  def change
    add_column :decidim_attachments, :weight, :integer, null: false, default: 0
  end
end
