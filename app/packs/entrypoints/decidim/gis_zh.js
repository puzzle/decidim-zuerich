import 'leaflet'
import 'proj4'
import 'proj4leaflet'
import 'leaflet-svgicon'
import 'leaflet.markercluster'
import '../../src/map.js' // must import this file in order to run any maps at all
import MapMarkersController from 'src/decidim/map/controller/markers.js'
import MapStaticController from 'src/decidim/map/controller/static.js'

((exports) => {
  const $ = exports.$; // eslint-disable-line
  const L = exports.L; // eslint-disable-line

  exports.Decidim = exports.Decidim || {};
  class GisZhMapController extends MapMarkersController {
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
    }

    setCoordinateReferenceSystem() {
      // Swiss coordinate system LV95 is used in these maps, see https://epsg.io/2056

      // Specifications are taken from here:
      // https://opendatazurich.github.io/geoportal/#beispiel-mit-dem-wmts-basiskarte-z%C3%BCrich-raster-grau-mit-epsg2056-lv95
      this.map.options.crs = new L.Proj.CRS('EPSG:2056', '+proj=somerc +lat_0=46.95240555555556 +lon_0=7.439583333333333 +k_0=1 +x_0=2600000 +y_0=1200000 +ellps=bessel +towgs84=674.374,15.056,405.346,0,0,0,0 +units=m +no_defs', {
        origin: [2480237.0, 1315832.0],
        resolutions: this.getResolutions()
      });
    }

    getResolutions() {
      return [67.7333333333, 33.8666666667, 16.9333333333, 8.4666666667, 4.2333333333, 2.1166666667, 1.0583333333, 0.5291666667, 0.2645833333, 0.1322916667, 0.0661458333]
    }

    addTileLayers() {
      const tileLayers = Object.fromEntries(Object.entries(this.config.layers).map(([_, layer]) => {

        return [
          layer.name,
          L.tileLayer(
            layer.url, {
            minZoom: 0,
            maxZoom: this.getResolutions().length - 1,
            tileSize: 512,
          }).addTo(this.map)
        ];

      }));

      L.control.layers(tileLayers).addTo(this.map);
    }

    setViewport() {
      if (this.config.markers.length === 0) {
        const center = this.config.defaultCenter ? [this.config.defaultCenter.lat, this.config.defaultCenter.lng] : [0,0];
        const bounds = new L.LatLngBounds([center, center]);
        this.map.fitBounds(bounds, {padding: [100, 100], maxZoom: 2});
      } else {
        const bounds = new L.LatLngBounds(this.config.markers.map((markerData) => [markerData.latitude, markerData.longitude]));
        this.map.fitBounds(bounds, {padding: [100, 100], maxZoom: 10});
      }
    }
  }

  // We need to replace the dynamic map controller of decidim and use our own
  exports.Decidim.createMapController = (mapId, config) => {
    if (config.type === "static") {
      return new MapStaticController(mapId, config);
    }

    return new GisZhMapController(mapId, config);
  }

  $("[data-decidim-map]").on("configure.decidim", (_ev, map, _mapConfig) => {
    $(map._container).css("display", "block");
  });

})(window);
