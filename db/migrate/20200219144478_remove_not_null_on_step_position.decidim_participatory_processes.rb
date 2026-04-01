# frozen_string_literal: true

# This migration comes from decidim_participatory_processes (originally 20161107152228)
# This file has been modified by `decidim upgrade:migrations` task on 2026-03-31 11:42:00 UTC
class RemoveNotNullOnStepPosition < ActiveRecord::Migration[5.0]
  def change
    change_column :decidim_participatory_process_steps, :position, :integer, null: true
  end
end
