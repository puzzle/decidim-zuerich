# frozen_string_literal: true

# This migration comes from decidim_proposals (originally 20181016132225)
# This file has been modified by `decidim upgrade:migrations` task on 2026-03-31 11:42:00 UTC
class AddOrganizationAsAuthor < ActiveRecord::Migration[5.2]
  def change
    official_proposals = Decidim::Proposals::Proposal.unscoped.find_each.select do |proposal|
      proposal.coauthorships.count.zero?
    end

    official_proposals.each do |proposal|
      proposal.add_coauthor(proposal.organization)
    end
  end
end
