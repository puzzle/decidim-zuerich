export default function(baseClass) {
  class DragMarkerZhController extends baseClass {
    start() {
      super.start()
      if (this.config.marker) {
        this.addMarker(this.config.marker);
      }

      this.setViewport()
    }

    setViewport(markerData = this.marker) {
      const latitude = markerData?.latitude;
      const longitude = markerData?.longitude;
      if (!this.marker || !latitude) {
        const center = this.config.defaultCenter ? [this.config.defaultCenter.lat, this.config.defaultCenter.lng] : [0,0];
        const bounds = new L.LatLngBounds([center, center]);
        this.map.fitBounds(bounds, {padding: [100, 100], maxZoom: this.getNoMarkerMaxZoom()});
      } else {
        const bounds = new L.LatLngBounds([[latitude, longitude]]);
        this.map.fitBounds(bounds, {padding: [10, 10], maxZoom: this.getSingleMarkerMaxZoom()});
      }
    }

    addMarker(markerData) {
      // Decidim sometimes confuses latitude and longitude. Make sure they are the right way round.
      // In Switzerland, latitude is always bigger (around 45) than longitude (around 8).
      const correctedMarkerData = {
        latitude: Math.max(markerData.latitude, markerData.longitude),
        longitude: Math.min(markerData.latitude, markerData.longitude),
      }
      super.addMarker(correctedMarkerData);
      this.setViewport(correctedMarkerData);
    }
  }

  return DragMarkerZhController;
}
