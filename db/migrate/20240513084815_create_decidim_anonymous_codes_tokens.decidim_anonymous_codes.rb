# frozen_string_literal: true
# This migration comes from decidim_anonymous_codes (originally 20240403091356)

class CreateDecidimAnonymousCodesTokens < ActiveRecord::Migration[6.1]
  def change
    create_table :decidim_anonymous_codes_tokens do |t|
      t.string :token, null: false
      t.integer :usage_count, default: 0, null: false

      t.references :group, null: false, index: { name: "decidim_anonymous_codes_tokens_on_group" }
      t.index [:token, :group_id], name: "index_anonymous_codes_token_group_uniqueness", unique: true
      t.timestamps
    end
  end
end
