import 'leaflet'
import 'leaflet-tilelayer-swiss'
import 'leaflet-svgicon'
import 'leaflet.markercluster'
import '../../src/map.js' // must import this file in order to run any maps at all
import MapMarkersController from 'src/decidim/map/controller/markers.js'
import DragMarkersController from 'src/decidim/map/controller/drag_marker.js'
import MapStaticController from 'src/decidim/map/controller/static.js'
import MapMarkersZhController from '../../src/map/map_markers_zh_controller'
import DragMarkerZhController from '../../src/map/drag_marker_zh_controller'

((exports) => {
  const $ = exports.$; // eslint-disable-line
  const L = exports.L; // eslint-disable-line

  exports.Decidim = exports.Decidim || {};
  const SwisstopoMapController = function(baseClass) {
    class SwisstopoMapControllerClass extends baseClass {
      start() {
        this.setCoordinateReferenceSystem()
        this.addTileLayers()

        // Don't render any markers that are out of bounds due to wrong geocoding
        // or because they're simply located someplace the GIS maps don't cover
        this.config.markers = (this.config.markers || []).filter(marker => {
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
        this.map.options.crs = L.CRS.EPSG2056;
      }

      addTileLayers() {
        L.tileLayer.swiss().addTo(this.map);
      }

      getNoMarkerMaxZoom() {
        return 19;
      }

      getSingleMarkerMaxZoom() {
        return 23;
      }

      getMarkerMaxZoom() {
        return 23;
      }
    }

    return SwisstopoMapControllerClass;
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
      DragMarkerZhController(SwisstopoMapController(DragMarkersController)) :
      MapMarkersZhController(SwisstopoMapController(MapMarkersController));

    return new controllerClass(mapId, config);
  }

  $("[data-decidim-map]").on("configure.decidim", (_ev, map, _mapConfig) => {
    $(map._container).css("display", "block");
  });

})(window);
