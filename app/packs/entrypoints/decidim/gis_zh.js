import 'leaflet'
import 'proj4'
import 'proj4leaflet'
import 'leaflet-svgicon'
import 'leaflet.markercluster'
import 'src/decidim/map.js'
import MapMarkersController from 'src/decidim/map/controller/markers.js'
import DragMarkersController from 'src/decidim/map/controller/drag_marker.js'
import MapStaticController from 'src/decidim/map/controller/static.js'
import MapMarkersZhController from '../../src/map/map_markers_zh_controller'
import DragMarkerZhController from '../../src/map/drag_marker_zh_controller'

((exports) => {
  const $ = exports.$; // eslint-disable-line
  const L = exports.L; // eslint-disable-line

  exports.Decidim = exports.Decidim || {};

  const GisZhMapController = function(baseClass) {
    class GisZhMapControllerClass extends baseClass {
      start() {
        this.setCoordinateReferenceSystem()
        this.addTileLayers()

        // decidim adds the markers for us, but if navigation maps are active,
        // a different L without the markercluster plugin is used for some reason.
        // Workaround is to overwrite the global L again from here.
        exports.L = L

        super.start()

        // Remove leaflet attribution
        this.map.attributionControl.setPrefix(false)
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

      getNoMarkerMaxZoom() {
        return 2;
      }

      getSingleMarkerMaxZoom() {
        return 6;
      }

      getMarkerMaxZoom() {
        return 2;
      }
    }

    return GisZhMapControllerClass;
  }

  // We need to replace the dynamic map controller of decidim and use our own
  exports.Decidim.createMapController = (mapId, config) => {

    // Fix mistakenly escaped href attribute in <template id="marker-popup">
    const markerPopupTemplate = document.querySelector('template#marker-popup');
    if (markerPopupTemplate) {
      const links = markerPopupTemplate.content.querySelectorAll('a[href="%24%7Blink%7D"]');
      links.forEach(link => {
        link.setAttribute('href', '${link}');
      });
    }

    if (config.type === 'static') {
      return new MapStaticController(mapId, config);
    }

    const controllerClass = (config.type === 'drag-marker') ?
      DragMarkerZhController(GisZhMapController(DragMarkersController)) :
      MapMarkersZhController(GisZhMapController(MapMarkersController));

    return new controllerClass(mapId, config);
  }

  $("[data-decidim-map]").on("configure.decidim", (_ev, map, _mapConfig) => {
    $(map._container).css("display", "block");
  });

})(window);
