// 'use strict';

function initMap(objects) {
    var myCoords = new google.maps.LatLng(objects[0]['latitude'], objects[0]['longitude']);
    var mapOptions = {
        center: myCoords,
        zoom: 8
    };

    var map = new google.maps.Map(document.getElementById('map'), mapOptions);

    for (var i=0; i < objects.length; i++){
        var markerData = objects[i];
        var latLng = new google.maps.LatLng(markerData.latitude, markerData.longitude);

        var marker = new google.maps.Marker({
            position: latLng,
            map: map,
            animation: google.maps.Animation.DROP,
            url: objects[i]['streetview']['share_link']
        });

        google.maps.event.addListener(marker, 'click', function() {
            window.location.href = this.url;
        });
    }
}
