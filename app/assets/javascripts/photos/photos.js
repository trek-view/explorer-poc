function initSceneMap(objects) {
  var myCoords = new google.maps.LatLng(objects[0]['latitude'], objects[0]['longitude']);
  var mapOptions = {
    center: myCoords,
    streetViewControl: false,
    zoom: 15
  };

  var map = new google.maps.Map(document.getElementById('map'), mapOptions);

  for (var i=0; i < objects.length; i++){
    var markerData = objects[i];
    var latLng = new google.maps.LatLng(markerData.latitude, markerData.longitude);

    var marker = new google.maps.Marker({
      position: latLng,
      map: map,
      animation: google.maps.Animation.DROP,
      photo: objects[i],
      tourer_photo_id: objects[i].tourer_photo_id
    });

    markers.push(marker)

    google.maps.event.addListener(marker, 'click', function() {
      viewer.loadScene(this.photo.tourer_photo_id)
    });
  }
}

function initSceneMapBox(objects) {
  if (!objects) return;
  // Get mapbox_token
  const mapboxTokenDom = document.getElementById('mapbox-token').childNodes;
  console.log('==== mapboxTokenDom: ', mapboxTokenDom[0].data);
  L.mapbox.accessToken = mapboxTokenDom[0].data;
  var latlng = L.latLng(
    parseFloat(objects[0]['latitude']),
    parseFloat(objects[0]['longitude'])
  );
  var map = L.mapbox.map('mapbox')
    .setView(latlng, 9)
    .addLayer(L.mapbox.styleLayer('mapbox://styles/mapbox/streets-v11'));

  console.log('====== map: ', map);
  for (var i=0; i < objects.length; i++) {
    var markerData = objects[i];
    console.log('===== markerData: ', markerData);
    
    const markerColor = '#d6eff9';
    const markerHtmlStyles = `
      background-color: ${markerColor};
      background-color: #d6eff9;
      width: 1.25rem;
      height: 1.25rem;
      display: block;
      border-radius: 1.5rem;
      transform: rotate(45deg);
      border: 2px solid #7cb4c6;`;
    const markerIcon = L.divIcon({
      className: "my-custom-pin",
      iconAnchor: [0, 0],
      labelAnchor: [-3, 0],
      popupAnchor: [0, -10],
      html: `<span style="${markerHtmlStyles}" />`
    });

    var marker = L.marker(
      new L.latLng(
        parseFloat(markerData.latitude),
        parseFloat(markerData.longitude)
      ),
      {
        icon: markerIcon,
        data: markerData
    }).bindPopup(`${markerData.latitude}, ${markerData.longitude}`).addTo(map);
    markers.push(marker);

    // var featureLayer = L.mapbox.featureLayer().addTo(map);
    marker.on('click', function(e) {
      viewer.loadScene(e.target.options.data.tourer_photo_id);
    });
  }
}

