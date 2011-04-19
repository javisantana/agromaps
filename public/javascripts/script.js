var colors = [
    {icon:"red",rgb:"FF3333"},
    {icon:"blue",rgb:"0098CB"},
    {icon:"grey",rgb:"333333"},
    {icon:"pink",rgb:"F40092"},
    {icon:"purple",rgb:"9600C8"},
    {icon:"yellow",rgb:"FDCA00"}
];

var counter=0;

var map;
var bbox;

$(function() {

  var spinner = {
    start: function() { $("#spinner").show();},
    stop:  function() { $("#spinner").hide();}
  };

  map = {
    lat: 37.4419,
    lng: -122.1419,
    zoom: 13,

    init: function() {
      var _this = this;
      if (GBrowserIsCompatible()) {
        this.canvas = new GMap2(document.getElementById("map"));
        this.canvas.setCenter(new GLatLng(this.lat, this.lng), this.zoom);
        this.canvas.setMapType(G_SATELLITE_MAP);
        //this.canvas.setUIToDefault();

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
  displayPlots();
});


function displayPlots() {
    
    
    //Polygons
    bbox = new GLatLngBounds();
    $.each(plots_data.variable_rate_maps, function(index, vrm) { 
        //Draw a box on the left side
        
        
        
        $.each(vrm.plots, function(index, plot) { 
            //iterate over the plots
            createPolygons(plot.geojson,colors[counter].rgb,counter);
        });
        
        counter=counter+1;
        if (counter==colors.length) {
            counter=0;
        }
    });
    
    map.canvas.setCenter( bbox.getCenter( ), map.canvas.getBoundsZoomLevel( bbox )-1 );
    
    
    
    
}


function createPolygons(geojson,color,counter) {
    
    if (geojson.coordinates) {
      $.each(geojson.coordinates, function(index, poly) { 
        var _coords=[];
        $.each(poly[0], function(index, c) {
            var ll = new GLatLng(c[1], c[0]);
          _coords.push(ll);
          bbox.extend(ll);
        });
        
        var polygon = new GPolygon(_coords, "#"+color, 2, 1, "#ffffff", 0.4);
        map.canvas.addOverlay(polygon);
      });
    }
}
