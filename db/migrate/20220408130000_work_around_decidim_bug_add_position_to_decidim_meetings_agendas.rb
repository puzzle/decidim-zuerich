# frozen_string_literal: true

class WorkAroundDecidimBugAddPositionToDecidimMeetingsAgendas < ActiveRecord::Migration[6.0]
  def change
    add_column :decidim_meetings_agendas, :position, :integer, default: 0
  end
end
