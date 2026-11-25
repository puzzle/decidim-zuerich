# frozen_string_literal: true

# This migration comes from decidim_meetings (originally 20210520134834)
# This file has been modified by `decidim upgrade:migrations` task on 2026-03-31 11:42:00 UTC
class AddStatusToMeetingsQuestions < ActiveRecord::Migration[6.0]
  def change
    add_column :decidim_meetings_questions, :status, :integer, default: 0, index: true
  end
end
