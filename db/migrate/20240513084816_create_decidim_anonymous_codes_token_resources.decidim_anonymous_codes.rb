# frozen_string_literal: true
# This migration comes from decidim_anonymous_codes (originally 20240403091376)

class CreateDecidimAnonymousCodesTokenResources < ActiveRecord::Migration[6.1]
  def change
    create_table :decidim_anonymous_codes_token_resources do |t|
      t.references :token, null: false, index: { name: "decidim_anonymous_codes_token_resources_on_token" }
      t.references :resource, polymorphic: true, null: false, index: { name: "decidim_anonymous_codes_token_resources_on_resource" }
      t.timestamps
    end
  end
end
