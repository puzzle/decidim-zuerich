module Decidim
  module Map
    module Provider
      module DynamicMap
        class GisZh < ::Decidim::Map::DynamicMap

          def builder_options
            configuration
              .merge(super)
              .symbolize_keys
              .deep_merge(organization.map_config.symbolize_keys)
          end

          # A builder for the GIS LU maps which need to be configured differently
          # than "normal" OSM based tile service providers.
          class Builder < Decidim::Map::DynamicMap::Builder
            # @see Decidim::Map::DynamicMap::Builder#append_assets
            def append_assets
              template.append_stylesheet_pack_tag("decidim_map")
              template.append_javascript_pack_tag("decidim/gis_zh", defer: false)
              template.append_javascript_pack_tag("decidim_proposals", defer: false)
            end
          end
        end
      end
    end
  end
end
