$(function() {

  var spinner = {
    start: function() { $("#spinner").show();},
    stop:  function() { $("#spinner").hide();}
  };

  var map = {
    lat: 37.4419,
    lng: -122.1419,
    zoom: 13,

    init: function() {
      var _this = this;
      if (GBrowserIsCompatible()) {
        this.canvas = new GMap2(document.getElementById("map"));
        this.canvas.setCenter(new GLatLng(this.lat, this.lng), this.zoom);
        this.canvas.setUIToDefault();

        $("input[name='municipality']").autocomplete({
          source: function(request, response) {

            $.get("http://localhost:3000/municipalities.json", {name:request.term}, function(data) {

              response($.map(data, function(item) {
              return {
                label: item.municipality_name,
                value: item.municipality_name }
            }))
            });
          },
          select: function(event, ui) { }
        });
      }
    }
  }

  map.init();
});


function displayPlots() {
    
}