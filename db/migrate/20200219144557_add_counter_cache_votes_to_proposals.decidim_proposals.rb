# frozen_string_literal: true

# This migration comes from decidim_proposals (originally 20170118120151)
# This file has been modified by `decidim upgrade:migrations` task on 2026-03-31 11:42:00 UTC
class AddCounterCacheVotesToProposals < ActiveRecord::Migration[5.0]
  def change
    add_column :decidim_proposals_proposals, :proposal_votes_count, :integer, null: false, default: 0
  end
end
