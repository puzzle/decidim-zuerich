# frozen_string_literal: true
# This migration comes from decidim (originally 20180206143340)

class FixReferenceForAllResources < ActiveRecord::Migration[5.1]
  def up
    # This fix fails with later added references
  end

  def down; end
end
