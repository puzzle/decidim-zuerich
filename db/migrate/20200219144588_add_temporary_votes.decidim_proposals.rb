# frozen_string_literal: true

# This migration comes from decidim_proposals (originally 20181010114622)
# This file has been modified by `decidim upgrade:migrations` task on 2026-03-31 11:42:00 UTC
class AddTemporaryVotes < ActiveRecord::Migration[5.2]
  def change
    change_table :decidim_proposals_proposal_votes do |t|
      t.boolean :temporary, null: false, default: false
    end
  end
end
