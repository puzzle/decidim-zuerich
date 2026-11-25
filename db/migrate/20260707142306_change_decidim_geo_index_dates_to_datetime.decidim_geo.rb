# frozen_string_literal: true

# This migration comes from decidim_geo (originally 20260429112824)
class ChangeDecidimGeoIndexDatesToDatetime < ActiveRecord::Migration[7.0]
  def change
    change_column :decidim_geo_indexes, :start_date, :datetime
    change_column :decidim_geo_indexes, :end_date, :datetime
  end
end
