# frozen_string_literal: true

class RevertDecidimGeoUpgrade < ActiveRecord::Migration[7.0]
  require_relative '20260107122143_replace_geo_enable_with_geo_mode_reverted.decidim_geo'
  require_relative '20260107122144_add_esri_tile_reverted.decidim_geo'

  def change
    revert AddEsriTileReverted
    revert ReplaceGeoEnableWithGeoModeReverted
  end
end
