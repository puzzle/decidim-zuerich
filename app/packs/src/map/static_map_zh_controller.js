export default function(baseClass) {
  class StaticMapZhController extends baseClass {
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

      this.setViewport()
    }

    setViewport() {
      const latitude = this.config.latitude;
      const longitude = this.config.longitude;
      if (!latitude || !longitude) {
        const center = this.config.defaultCenter ? [this.config.defaultCenter.lat, this.config.defaultCenter.lng] : [0,0];
        const bounds = new L.LatLngBounds([center, center]);
        this.map.fitBounds(bounds, {padding: [100, 100], maxZoom: this.getNoMarkerMaxZoom()});
      } else {
        const bounds = new L.LatLngBounds([[latitude, longitude]]);
        this.map.fitBounds(bounds, {padding: [10, 10], maxZoom: this.getSingleMarkerMaxZoom() || this.getMarkerMaxZoom()});
      }
    }
  }

  return StaticMapZhController;
}
