$(function() {

  var lat = 37.4419;
  var lng = -122.1419;
  var zoom = 13;

  if (GBrowserIsCompatible()) {
    var map = new GMap2(document.getElementById("map"));
    map.setCenter(new GLatLng(lat, lng), zoom);
    map.setUIToDefault();
  }

});
