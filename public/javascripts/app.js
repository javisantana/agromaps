$(function() {
  var map = {
    lat: 37.4419,
    lng: -122.1419,
    zoom: 13,
    init: function() {
      if (GBrowserIsCompatible()) {
        this.canvas = new GMap2(document.getElementById("map"));
        this.canvas.setCenter(new GLatLng(this.lat, this.lng), this.zoom);
        this.canvas.setUIToDefault();
      }
    }
  }
  map.init();
});
