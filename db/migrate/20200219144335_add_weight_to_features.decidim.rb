# frozen_string_literal: true

# This migration comes from decidim (originally 20170125152026)
# This file has been modified by `decidim upgrade:migrations` task on 2026-03-31 11:41:59 UTC
class AddWeightToFeatures < ActiveRecord::Migration[5.0]
  def change
    add_column :decidim_features, :weight, :integer, default: 0
  end
end
