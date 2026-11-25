# frozen_string_literal: true

# This migration comes from decidim_meetings (originally 20190404132923)
# This file has been modified by `decidim upgrade:migrations` task on 2026-03-31 11:42:00 UTC
class AddUserGroupToMeetingsRegistrations < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_meetings_registrations, :decidim_user_group_id, :bigint
  end
end
