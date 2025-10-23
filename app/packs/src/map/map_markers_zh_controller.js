export default function(baseClass) {
  class MapMarkersZhControllerClass extends baseClass {
    start() {
      // Don't render any markers that are out of bounds due to wrong geocoding
      // or because they're simply located someplace the GIS maps don't cover
      this.config.markers = (this.config.markers || []).filter(marker => {
        return marker.latitude > this.config.mapLimits.latMin &&
          marker.latitude < this.config.mapLimits.latMax &&
          marker.longitude > this.config.mapLimits.lngMin &&
          marker.longitude < this.config.mapLimits.lngMax
      })

      // decidim adds the markers for us
      super.start()

      // Decidim bug: When no markers are present when loading the page,
      // No markerCluster layer is ever added, and then clearing the markers
      // fails (e.g. when switching the meeting filters on /meetings)
      if (this.markerClusters === null) {
        this.markerClusters = new L.MarkerClusterGroup();
        this.map.addLayer(this.markerClusters);
      }

      // Remove the href from any popup close buttons, to prevent tampering with
      // the meeting filters when closing a map marker popup
      if (this.markerClusters !== null) {
        this.markerClusters.on('popupopen', function (event) {
          document.querySelectorAll('.leaflet-popup-close-button').forEach(button => {
            button.removeAttribute('href');
          });
        });
      }

      this.setViewport()
    }

    addMarkers(markersData) {
      super.addMarkers((markersData || []).map(marker => {
        // Decidim sometimes confuses latitude and longitude. Make sure they are the right way round.
        // In Switzerland, latitude is always bigger (around 45) than longitude (around 8).
        return {
          ...marker,
          latitude: Math.max(marker.latitude, marker.longitude),
          longitude: Math.min(marker.latitude, marker.longitude),
        }
      }).filter(marker => {
        return marker.latitude > parseFloat(this.config.mapLimits.latMin) &&
          marker.latitude < parseFloat(this.config.mapLimits.latMax) &&
          marker.longitude > parseFloat(this.config.mapLimits.lngMin) &&
          marker.longitude < parseFloat(this.config.mapLimits.lngMax)
      }));
    }

    setViewport() {
      if (this.config.markers.length === 1) {
        const bounds = new L.LatLngBounds(this.config.markers.map((markerData) => [markerData.latitude, markerData.longitude]));
        this.map.fitBounds(bounds, {padding: [10, 10], maxZoom: this.getSingleMarkerMaxZoom()});
      } else {
        const center = this.config.defaultCenter ? [this.config.defaultCenter.lat, this.config.defaultCenter.lng] : [0,0];
        const bounds = new L.LatLngBounds([center, center]);
        this.map.fitBounds(bounds, {padding: [100, 100], maxZoom: this.getMarkerMaxZoom()});
      }
    }
  }

  return MapMarkersZhControllerClass;
}
