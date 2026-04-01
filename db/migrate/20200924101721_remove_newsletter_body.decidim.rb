# frozen_string_literal: true

# This migration comes from decidim (originally 20200327082954)
# This file has been modified by `decidim upgrade:migrations` task on 2026-03-31 11:42:00 UTC
class RemoveNewsletterBody < ActiveRecord::Migration[5.2]
  def change
    remove_column :decidim_newsletters, :body
  end
end
