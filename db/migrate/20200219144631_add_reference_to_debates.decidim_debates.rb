# frozen_string_literal: true

# This migration comes from decidim_debates (originally 20180119150434)
# This file has been modified by `decidim upgrade:migrations` task on 2026-03-31 11:42:00 UTC
class AddReferenceToDebates < ActiveRecord::Migration[5.1]
  class Debate < ApplicationRecord
    self.table_name = :decidim_debates_debates
  end

  def change
    add_column :decidim_debates_debates, :reference, :string
    Debate.find_each(&:touch)
  end
end
