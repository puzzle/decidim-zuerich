# frozen_string_literal: true

# This migration comes from decidim_meetings (originally 20170410074252)
# This file has been modified by `decidim upgrade:migrations` task on 2026-03-31 11:42:00 UTC
class RemoveNotNullReferenceMeetings < ActiveRecord::Migration[5.0]
  def change
    change_column_null :decidim_meetings_meetings, :reference, true
  end
end
