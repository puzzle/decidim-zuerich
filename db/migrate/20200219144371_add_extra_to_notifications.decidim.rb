# frozen_string_literal: true

# This migration comes from decidim (originally 20170906091718)
# This file has been modified by `decidim upgrade:migrations` task on 2026-03-31 11:41:59 UTC
class AddExtraToNotifications < ActiveRecord::Migration[5.1]
  def change
    add_column :decidim_notifications, :extra, :jsonb
  end
end
