/**
 * Created by jaminshanti on 3/20/16.
 */


function initialize() {
        var mapOptions = {
          zoom: 15,
          panControl: false,
          mapTypeControl: false,
          center: new google.maps.LatLng(41.89924, -87.62756),
          mapTypeId: google.maps.MapTypeId.ROADMAP
        }
        var map = new google.maps.Map(document.getElementById('map_canvas'),
                                      mapOptions);

        var image = 'http://maps.google.com/mapfiles/kml/pal2/icon2.png';
        var myLatLng = new google.maps.LatLng(41.89924, -87.62756);
        var marker = new google.maps.Marker({
            position: myLatLng,
            map: map,
            animation: google.maps.Animation.DROP,
            icon: image,
        });

        var styles = [
                  {
                    stylers: [
                      { hue: "#ff9f67" },
                      { saturation: -20 },
                      { gamma: 1.50 }
                    ]
                  },{
                    featureType: "road",
                    elementType: "geometry",
                    stylers: [
                      { lightness: 100 },
                      { visibility: "simplified" }
                    ]
                  },{
                    featureType: "road",
                    elementType: "labels.text.stroke",
                    stylers: [
                      { visibility: "off" }
                    ]
                  },

                  {
                    featureType: "water",
                    elementType: "geometry.fill",
                    stylers: [
                        { visibility: "on" },
                        { color: "#ffa066" },
                        { lightness: 80 }
                    ]
                    }
                ];
    map.setOptions({styles: styles});

    // Code for infowindow
    var popup=new google.maps.InfoWindow({
        content: "Hello"
    });
    google.maps.event.addListener(marker, 'click', function(e) {
        console.log(e);
        popup.open(map, this);
    });
}
initialize();

});//]]>


