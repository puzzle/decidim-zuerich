# frozen_string_literal: true

# This migration comes from decidim_meetings (originally 20201111133246)
# This file has been modified by `decidim upgrade:migrations` task on 2026-03-31 11:42:00 UTC
class AddSaltToDecidimMeetings < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_meetings_meetings, :salt, :string
    # we leave old entries empty to maintain the old pad reference
  end
end
