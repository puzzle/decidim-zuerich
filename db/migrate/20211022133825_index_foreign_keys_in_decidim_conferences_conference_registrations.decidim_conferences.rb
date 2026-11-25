# frozen_string_literal: true

# This migration comes from decidim_conferences (originally 20200320105915)
# This file has been modified by `decidim upgrade:migrations` task on 2026-03-31 11:41:59 UTC
class IndexForeignKeysInDecidimConferencesConferenceRegistrations < ActiveRecord::Migration[5.2]
  def change
    add_index :decidim_conferences_conference_registrations, :decidim_conference_registration_type_id, name: "idx_conferences_registrations_on_registration_type_id"
  end
end
