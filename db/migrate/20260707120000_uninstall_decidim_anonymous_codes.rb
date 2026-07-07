# This migration reverses all migrations from decidim_initiatives

require "#{Rails.root}/db/migrate/20240513084814_create_decidim_anonymous_codes_groups.decidim_anonymous_codes"
require "#{Rails.root}/db/migrate/20240513084815_create_decidim_anonymous_codes_tokens.decidim_anonymous_codes"
require "#{Rails.root}/db/migrate/20240513084816_create_decidim_anonymous_codes_token_resources.decidim_anonymous_codes"

class UninstallDecidimAnonymousCodes < ActiveRecord::Migration[5.2]
  def up
    drop_table :decidim_anonymous_codes_token_resources
    drop_table :decidim_anonymous_codes_tokens
    drop_table :decidim_anonymous_codes_groups
  end

  def down
    CreateDecidimAnonymousCodesGroups.up
    CreateDecidimAnonymousCodesTokens.up
    CreateDecidimAnonymousCodesTokenResources.up
  end
end
