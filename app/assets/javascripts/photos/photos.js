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
  L.mapbox.accessToken = 'pk.eyJ1IjoidmFsZXJpaWFkaWR1c2hvayIsImEiOiJjazcxNnd6OGgwM2lyM2xsYzB4ZWZ1YWR6In0.Fjhltt0WG0t3YH3kFZpIfQ';
  var latlng = L.latLng(
    parseFloat(objects[0]['latitude']),
    parseFloat(objects[0]['longitude'])
  );
  var map = L.mapbox.map('mapbox')
    .setView(latlng, 9)
    .addLayer(L.mapbox.styleLayer('mapbox://styles/mapbox/streets-v11'));

  console.log('====== map: ', map);
  // var featureLayer = null;
  for (var i=0; i < objects.length; i++) {
    var markerData = objects[i];
    console.log('===== markerData: ', markerData);

    var marker = L.marker(
      new L.latLng(
        parseFloat(markerData.latitude),
        parseFloat(markerData.longitude)
      ),
      {
        icon: L.mapbox.marker.icon({
            'marker-color': 'ff8888'
        }),
        data: markerData
    }).bindPopup(`${markerData.latitude}, ${markerData.longitude}`).addTo(map);

    console.log('===== marker: ', marker);
    markers.push(marker);

    // var featureLayer = L.mapbox.featureLayer().addTo(map);
    marker.on('click', function(e) {
      console.log('===== click: e: ', e.target);
      viewer.loadScene(e.target.options.data.tourer_photo_id);
    });
  }
  
  

  // map.on('click', function(ev) {
  //   viewer.loadScene(ev.optioins.data.tourer_photo_id);
  // });
}

document.addEventListener("DOMContentLoaded", function(){
  if (gon.pannellum_config === undefined) {
    return false;
  }
  console.log('==== gon.pannellum_config: ', gon.pannellum_config);
  markers = [];
  console.log('==== pannellum: ', pannellum);
  viewer = pannellum.viewer('panorama', gon.pannellum_config);
  console.log('==== viewer: ', viewer);

  // initSceneMap(gon.photos);
  initSceneMapBox(gon.photos);

  currentScene = viewer.getScene();
  console.log('===== currentScene: ', currentScene);
  console.log('===== markers: ', markers);
  if (currentScene) {
    currentMarker = markers.find(obj => obj.tourer_photo_id == currentScene);
    if (currentMarker) {
      currentMarker.setAnimation(google.maps.Animation.BOUNCE);
    }
  }

  viewer.on('scenechange', function () {
    hotSpot = gon.pannellum_config.scenes[currentScene].hotSpots.find(obj => obj.sceneId == viewer.getScene())
    photo = gon.photos.find(obj => obj.tourer_photo_id == viewer.getScene())

    iframe_url = '<iframe width="600" height="400" allowfullscreen style="border-style:none;" src="https://cdn.pannellum.org/2.5/pannellum.htm#panorama=' + 
      photo.image.med.url + 
      '&amp;title=' + encodeURIComponent(gon.tour_name) + 
      '&amp;author=' + encodeURIComponent(gon.author_name) + 
      '&amp;autoLoad=true"></iframe><p><a href="' + 
      gon.root_url + 'photos/' + photo.id + 
      '" target="_blank">View on Trek View Explorer</a></p>'

    $('.custom-tooltip').text(iframe_url)

    if (hotSpot) {
      viewer.setYaw(hotSpot.yaw)
    }

    prevMarker = markers.find(obj => obj.tourer_photo_id == currentScene)

    currentScene = viewer.getScene()

    currentMarker = markers.find(obj => obj.tourer_photo_id == currentScene)

    prevMarker.setAnimation(google.maps.Animation.DROP)
    currentMarker.setAnimation(google.maps.Animation.BOUNCE)
  });
});
