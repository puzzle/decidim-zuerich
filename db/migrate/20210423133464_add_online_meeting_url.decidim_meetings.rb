# frozen_string_literal: true

# This migration comes from decidim_meetings (originally 20201006140511)
# This file has been modified by `decidim upgrade:migrations` task on 2026-03-31 11:42:00 UTC
class AddOnlineMeetingUrl < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_meetings_meetings, :online_meeting_url, :string
  end
end
