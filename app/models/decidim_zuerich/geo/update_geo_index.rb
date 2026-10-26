# frozen_string_literal: true

# Decidim Zuerich Override
#
# Created at: 2026-10-26
# Author: Thomas Burkhalter
#
# Original:
#   Module: decidim-decidim_geo
#   File: lib/decidim/geo/update_geo_index.rb
#   Method: Decidim::Geo::UpdateGeoIndex#update_decidim_geo_index
#
# Why?:
#   https://github.com/puzzle/decidim-zuerich/issues/641
#   After commit, Decidim Geo re-fetches the record to update its map index.
#   When the record was destroyed (e.g. a discarded proposal draft), the lookup
#   returns nil and the updater crashes on `nil.id`, turning the request into a 500.
#   Instead, when the record is gone, we just remove it from the Geo index.
#
#   Prepended to every Geo-indexed model in config/initializers/decidim_zuerich_customization.rb.
#   Remove once decidim-module-geo ships the fix (reported upstream as a patch).
module DecidimZuerich
  module Geo
    module UpdateGeoIndex
      def update_decidim_geo_index
        # Not destroyed?: Rails may run after_commit on another loaded instance of the same record
        return super unless decidim_geo_enabled? && !self.class.exists?(id)

        Decidim::Geo::Index.where(resource_id: id, resource_type: decidim_geo_manifest.to_s).destroy_all
      end
    end
  end
end
