# frozen_string_literal: true

# This migration comes from decidim (originally 20240717093514)
# This file has been modified by `decidim upgrade:migrations` task on 2026-03-31 11:42:00 UTC
class AddRegisteredOnlyToDecidimShareTokens < ActiveRecord::Migration[7.0]
  def change
    add_column :decidim_share_tokens, :registered_only, :boolean
  end
end
