# frozen_string_literal: true

# This migration comes from decidim_blogs (originally 20171129131353)
# This file has been modified by `decidim upgrade:migrations` task on 2026-03-31 11:41:59 UTC
class CreateDecidimBlogsPosts < ActiveRecord::Migration[5.0]
  def change
    create_table :decidim_blogs_posts do |t|
      t.jsonb :title
      t.jsonb :body
      t.references :decidim_component, index: true
      t.timestamps
    end
  end
end
