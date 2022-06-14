module Decidim
  module Map
    module Provider
      module DynamicMap
        class Swisstopo < ::Decidim::Map::DynamicMap

          def builder_options
            configuration.merge(super)
          end

          # A builder for the GIS LU maps which need to be configured differently
          # than "normal" OSM based tile service providers.
          class Builder < Decidim::Map::DynamicMap::Builder
            # @see Decidim::Map::DynamicMap::Builder#javascript_snippets
            def javascript_snippets
              [
                  template.javascript_pack_tag("decidim/swisstopo"),
                  template.javascript_pack_tag("decidim_proposals")
              ].join
            end
          end
        end
      end
    end
  end
end
