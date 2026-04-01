# frozen_string_literal: true

# This migration comes from decidim (originally 20190618075906)
# This file has been modified by `decidim upgrade:migrations` task on 2026-03-31 11:42:00 UTC
class AddConfidentialToDoorkeeperApplication < ActiveRecord::Migration[5.2]
  def change
    add_column(
      :oauth_applications,
      :confidential,
      :boolean,
      null: false,
      default: true # maintaining backwards compatibility: require secrets
    )
  end
end
