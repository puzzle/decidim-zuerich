import 'leaflet'
import 'leaflet-tilelayer-swiss'
import 'leaflet-svgicon'
import 'leaflet.markercluster'
import '../../src/map.js' // must import this file in order to run any maps at all
import MapMarkersController from 'src/decidim/map/controller/markers.js'
import MapStaticController from 'src/decidim/map/controller/static.js'

((exports) => {
  const $ = exports.$; // eslint-disable-line
  const L = exports.L; // eslint-disable-line

  exports.Decidim = exports.Decidim || {};
  class SwisstopoMapController extends MapMarkersController {
    start() {
      this.setCoordinateReferenceSystem()
      this.addTileLayers()

      // Don't render any markers that are out of bounds due to wrong geocoding
      // or because they're simply located someplace the GIS maps don't cover
      this.config.markers = this.config.markers.filter(marker => {
        return marker.latitude > this.config.mapLimits.latMin &&
          marker.latitude < this.config.mapLimits.latMax &&
          marker.longitude > this.config.mapLimits.lngMin &&
          marker.longitude < this.config.mapLimits.lngMax
      })

      // decidim adds the markers for us, but if navigation maps are active,
      // a different L without the markercluster plugin is used for some reason.
      // Workaround is to overwrite the global L again from here.
      exports.L = L
      super.start()

      this.setViewport()

      // Remove leaflet attribution
      this.map.attributionControl.setPrefix(false)
    }

    setCoordinateReferenceSystem() {
      // Swiss coordinate system LV95 is used in these maps, see https://epsg.io/2056
      this.map.options.crs = L.CRS.EPSG2056;
    }

    addTileLayers() {
      L.tileLayer.swiss().addTo(this.map);
    }

    setViewport() {
      if (this.config.markers.length === 0) {
        const center = this.config.defaultCenter ? [this.config.defaultCenter.lat, this.config.defaultCenter.lng] : [0,0];
        const bounds = new L.LatLngBounds([center, center]);
        this.map.fitBounds(bounds, {padding: [100, 100], maxZoom: 19});
      } else {
        const bounds = new L.LatLngBounds(this.config.markers.map((markerData) => [markerData.latitude, markerData.longitude]));
        this.map.fitBounds(bounds, {padding: [100, 100], maxZoom: 23});
      }
    }
  }

  // We need to replace the dynamic map controller of decidim and use our own
  exports.Decidim.createMapController = (mapId, config) => {
    if (config.type === "static") {
      return new MapStaticController(mapId, config);
    }

    return new SwisstopoMapController(mapId, config);
  }

  $("[data-decidim-map]").on("configure.decidim", (_ev, map, _mapConfig) => {
    $(map._container).css("display", "block");
  });

})(window);
