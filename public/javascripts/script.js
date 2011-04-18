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

        $("form").submit(function() {
          var polygon_id = $("input[name='polygon_id']").val();
          var plot_id = $("input[name='plot_id']").val();

          console.log(_this.municipality_id);
          console.log(_this.province_id);

          $.get("/plots.json", {province_id:_this.province_id, municipality_id:_this.municipality_id, polygon_id:polygon_id, plot_number:plot_id}, function(data) {
            console.log("ok");
            //   console.log(data);
          });

          return false;
        });

        $("input[name='municipality']").autocomplete({
          minLength: 4,
          source: function(request, response) {

            $.get("/municipalities.json", {name:request.term}, function(data) {

              response($.map(data, function(item) {

                return {
                  municipality_id: item.municipality_id,
                  province_id: item.province_id,
                  value: item.municipality_name.toLowerCase() + ", " + item.province_name.toLowerCase()}
              }))
            });
          },
          select: function(event, selection) {
            _this.province_id     = selection.item.province_id;
            _this.municipality_id = selection.item.municipality_id;
          }
        });
      }
    }
  }

  map.init();
});


function displayPlots() {
    
}
